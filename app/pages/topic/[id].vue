<script setup lang="ts">
const route = useRoute();
const id = route.params.id as string;

const isOpen = ref(false);
const state = reactive({ content: "" });

const { data: posts, refresh } = await useFetch(`/api/posts?topicId=${id}`);

async function createPost() {
  await $fetch("/api/posts", {
    method: "POST",
    body: { content: state.content, topicId: id },
  });
  state.content = "";
  isOpen.value = false;
  refresh();
}
</script>

<template>
  <div class="p-6 space-y-4">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Thread</h1>
      <UButton @click="isOpen = true">Reply</UButton>
    </div>

    <div v-if="posts && posts.length > 0" class="space-y-4">
      <UCard v-for="post in posts" :key="post.id">
        <div class="flex gap-4">
          <div class="w-32 shrink-0">
            <UAvatar />
            <p class="text-sm font-medium mt-1">{{ post.username }}</p>
            <p class="text-xs text-gray-400">{{ new Date(post.createdAt).toLocaleDateString() }}</p>
          </div>
          <div class="flex-1">
            <p>{{ post.content }}</p>
          </div>
        </div>
      </UCard>
    </div>

    <p v-else class="text-gray-400">No replies yet.</p>

    <UModal v-model:open="isOpen" title="Reply">
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
  </div>
</template>
