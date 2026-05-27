<script setup lang="ts">
import Post from "@/components/Post.vue";

const isOpen = ref(false);

const state = reactive({ title: "", description: "" });

async function createTopic() {
  await $fetch("/api/topics", {
    method: "POST",
    body: state,
  });
  isOpen.value = false;
}

const topics = await $fetch("/api/topics");
console.log(topics);
</script>

<template>
  <Post
    v-for="topic in topics"
    :key="topic.id"
    :name="topic.username"
    :text="topic.description"
  />

  <UModal v-model:open="isOpen" title="Create New Topic">
    <UButton @click="isOpen = true">Create New Topic</UButton>
    <template #body>
      <div class="space-y-4">
        <UFormField label="Title" name="title">
          <UInput v-model="state.title" class="w-full" />
        </UFormField>
        <UFormField label="Description" name="description">
          <UInput v-model="state.description" class="w-full" />
        </UFormField>
        <div class="flex justify-end">
          <UButton @click="createTopic">Create</UButton>
        </div>
      </div>
    </template>
  </UModal>
</template>
