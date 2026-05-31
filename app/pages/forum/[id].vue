<script setup lang="ts">
import { hasPermission } from "#shared/utils/permissions";

const { loggedIn, clear, user } = useUserSession();

const route = useRoute();
const id = route.params.id as string;

const STATUS_LABELS = {
  true: "Resolved",
  false: "Open",
};

const isCreateOpen = ref(false);
const isDeleteOpen = ref(false);
const isEditOpen = ref(false);
const postToDelete = ref<string | null>(null);
const postContentToEdit = ref<string | null>(null);
const postToEdit = ref<string | null>(null);
const state = reactive({ content: "" });

const { data: posts, refresh } = await useFetch(`/api/posts?topicId=${id}`);

const label = posts.value?.[0]?.TopicTitle;
const isResolved = posts.value?.[0]?.isResolved;

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

function openDelete(postId: string) {
  postToDelete.value = postId;
  isDeleteOpen.value = true;
}

function openEdit(postId: string, content: string) {
  postToEdit.value = postId;
  postContentToEdit.value = content;
  isEditOpen.value = true;
}

async function createPost() {
  await $fetch("/api/posts", {
    method: "POST",
    body: { content: state.content, topicId: id },
  });
  state.content = "";
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
      <UBadge :color="isResolved ? 'error' : 'success'">{{
        STATUS_LABELS[isResolved]
      }}</UBadge>
      <h1 class="text-2xl font-bold">{{ label }}</h1>
      <div class="flex justify-between items-center gap-2">
        <UButton @click="isCreateOpen = true">Reply</UButton>
      </div>
    </div>

    <div v-if="posts && posts.length > 0" class="space-y-4">
      <UCard v-for="post in posts" :key="post.id">
        <div class="flex gap-4">
          <div class="w-32 shrink-0">
            <UAvatar />
            <p class="text-sm font-medium mt-1">{{ post.username }}</p>
            <p class="text-xs text-gray-400">
              {{ new Date(post.createdAt).toLocaleString() }}
            </p>
          </div>
          <div class="flex-1">
            <p>{{ post.content }}</p>
          </div>
          <UButton
            v-if="canEdit(post.userId)"
            @click="openEdit(post.id, post.content)"
            >Edit</UButton
          >
          <UButton
            v-if="canDelete(post.userId)"
            @click="openDelete(post.id)"
            color="error"
            size="sm"
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
          <UFormField label="Your reply" name="content">
            <UTextarea v-model="state.content" class="w-full" :rows="4" />
          </UFormField>
          <div class="flex justify-end">
            <UButton @click="createPost">Post</UButton>
          </div>
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
  </div>
</template>
