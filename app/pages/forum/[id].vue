<script setup lang="ts">
import { hasPermission } from "#shared/utils/permissions";

const { loggedIn, clear, user } = useUserSession();

//console.log(user.value.isVerified);
//console.log(user.value);

const route = useRoute();
const id = route.params.id as string;

const selectedFiles = ref<File[]>([]);

const STATUS_LABELS = {
  true: "Resolved",
  false: "Open",
};

const isCreateOpen = ref(false);
const isDeleteOpen = ref(false);
const isResolveOpen = ref(false);
const isEditOpen = ref(false);
const postToDelete = ref<string | null>(null);
const postContentToEdit = ref<string | undefined>(undefined);
const postToEdit = ref<string | null>(null);
const state = reactive({ content: "" });

const { data: posts, refresh } = await useFetch(`/api/posts?topicId=${id}`);

const label = computed(() => posts.value?.[0]?.TopicTitle);
const isResolved = computed(() => posts.value?.[0]?.isResolved);

const resolvedModalTitle = computed(() => {
  const label = STATUS_LABELS[String(isResolved.value)] ?? STATUS_LABELS.false;
  return `Do you want to ${label.toLowerCase()} the topic?`;
});

function canDelete(postUserId: string): boolean {
  if (!user.value) return false;

  if (postUserId === user.value.id) {
    return hasPermission(user.value.permissions, "deleteOwnContent");
  }
  return hasPermission(user.value.permissions, "deleteAnyContent");
}

function canEdit(postUserId: string): boolean {
  if (!user.value) return false;
  if (postUserId === user.value.id) {
    return hasPermission(user.value.permissions, "editOwnContent");
  }
  return false;
}

const canPost = computed(
  () => loggedIn.value && user.value?.isVerified === true,
);

const canClose = computed(() => {
  if (!user.value) return false;

  if (user.value.role === "admin" || user.value.role === "moderator") {
    return true;
  }

  return false;
});

function openDelete(postId: string) {
  postToDelete.value = postId;
  isDeleteOpen.value = true;
}

//console.log(topicId);

function openResolve() {
  isResolveOpen.value = true;
}

async function resolveTopic() {
  await $fetch(`/api/topics/${id}`, { method: "PATCH" });
  isResolveOpen.value = false;
  refresh();
}

function openEdit(postId: string, content: string) {
  postToEdit.value = postId;
  postContentToEdit.value = content;
  isEditOpen.value = true;
}

async function createPost() {
  const formData = new FormData();
  formData.append("content", state.content);
  formData.append("topicId", id);
  for (const file of selectedFiles.value) {
    formData.append("files", file);
  }

  await $fetch("/api/posts", { method: "POST", body: formData });
  state.content = "";
  selectedFiles.value = [];
  isCreateOpen.value = false;
  refresh();
}

async function editPost() {
  try {
    await $fetch(`/api/posts/${postToEdit.value}`, {
      method: "PATCH",
      body: { content: postContentToEdit.value },
    });
    refresh();
  } finally {
    postContentToEdit.value = "";
    isEditOpen.value = false;
    postToEdit.value = null;
  }
}

async function deletePost() {
  try {
    await $fetch(`/api/posts/${postToDelete.value}`, { method: "DELETE" });
    refresh();
  } finally {
    isDeleteOpen.value = false;
    postToDelete.value = null;
  }
}
</script>

<template>
  <div class="p-6 space-y-4">
    <div class="flex justify-between items-center">
      <div class="flex items-center gap-2">
        <UBadge :color="isResolved ? 'error' : 'success'">{{
          STATUS_LABELS[String(isResolved)] ?? STATUS_LABELS.false
        }}</UBadge>
        <UButton
          v-if="canClose"
          @click="openResolve"
          :color="isResolved ? 'success' : 'error'"
          size="sm"
          >{{ isResolved ? "Open topic" : "Close topic" }}</UButton
        >
      </div>

      <h1 class="text-2xl font-bold">{{ label }}</h1>
      <div class="flex justify-between items-center gap-2">
        <UButton v-if="loggedIn" @click="isCreateOpen = true">Reply</UButton>
      </div>
    </div>

    <div v-if="posts && posts.length > 0" class="space-y-4">
      <UCard v-for="post in posts" :key="post.id">
        <div class="flex gap-4">
          <div class="w-32 shrink-0">
            <NuxtLink :to="`/user/${post?.userId}`">
              <UAvatar :src="post.avatarUrl ?? undefined" />
              <p class="text-sm font-medium mt-1">
                {{ post.userId ? post.username : "deleted User" }}
              </p>
              <p class="text-xs text-gray-400">
                {{ new Date(post.createdAt).toLocaleString() }}
              </p>
            </NuxtLink>
          </div>
          <div class="flex-1">
            <p>{{ post.content }}</p>
            <div v-if="post.attachments?.length">
              <a v-for="url in post.attachments" :href="url" target="blank">
                {{ url.split("/").pop() }}
              </a>
            </div>
          </div>
          <UButton
            v-if="canEdit(post.userId)"
            @click="openEdit(post.id, post.content)"
            size="sm"
            class="w-15 justify-center"
            >Edit</UButton
          >
          <UButton
            v-if="canDelete(post.userId)"
            @click="openDelete(post.id)"
            color="error"
            size="sm"
            class="w-15 justify-center"
            >Delete</UButton
          >
        </div>
      </UCard>
    </div>

    <p v-else class="text-gray-400">No replies yet.</p>

    <UModal
      v-model:open="isDeleteOpen"
      title="Do you really want to delete this post?"
    >
      <template #body>
        <div class="flex justify-center items-center space-x-4">
          <UButton @click="deletePost">Yes</UButton>
          <UButton color="error" @click="isDeleteOpen = false">Go Back</UButton>
        </div>
      </template>
    </UModal>

    <UModal v-model:open="isCreateOpen" title="Reply">
      <template #body>
        <div class="space-y-4">
          <div v-if="!canPost" class="text-sm text-yellow-500">
            Your account is not verified yet. Please check your inbox.
          </div>
          <template v-else>
            <UFormField label="Your reply" name="content">
              <UTextarea v-model="state.content" class="w-full" :rows="4" />
            </UFormField>
            <input
              type="file"
              multiple
              @change="
                (e) =>
                  (selectedFiles = Array.from(
                    (e.target as HTMLInputElement).files ?? [],
                  ))
              "
            />
            <div class="flex justify-end">
              <UButton @click="createPost">Post</UButton>
            </div>
          </template>
        </div>
      </template>
    </UModal>
    <UModal v-model:open="isEditOpen" title="Edit">
      <template #body>
        <div class="space-y-4">
          <UFormField label="Post Content" name="content">
            <UTextarea v-model="postContentToEdit" class="w-full" :rows="4" />
          </UFormField>
          <div class="flex justify-end">
            <UButton @click="editPost">Save</UButton>
            <UButton @click="isEditOpen = false" color="error">Discard</UButton>
          </div>
        </div>
      </template>
    </UModal>
    <UModal v-model:open="isResolveOpen" :title="resolvedModalTitle">
      <template #body>
        <div class="space-y-4">
          <div class="flex justify-end">
            <UButton @click="resolveTopic">Yes</UButton>
            <UButton @click="isResolveOpen = false" color="error"
              >Discard</UButton
            >
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
