<script setup lang="ts">
const route = useRoute();
const categoryId = route.query.categoryId as string;

const isOpen = ref(false);
const state = reactive({ title: "", description: "" });

const STATUS_LABELS = {
  true: "Resolved",
  false: "Open",
};

const { data: topics, refresh } = await useFetch(
  categoryId ? `/api/topics?categoryId=${categoryId}` : "/api/topics",
);

async function createTopic() {
  await $fetch("/api/topics", {
    method: "POST",
    body: { ...state, categoryId },
  });
  state.title = "";
  state.description = "";
  isOpen.value = false;
  refresh();
}
</script>

<template>
  <div class="p-6 space-y-4">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Threads</h1>
      <UButton @click="isOpen = true">New Thread</UButton>
    </div>

    <NuxtLink
      v-for="topic in topics"
      :key="topic.id"
      :to="`/forum/${topic.id}`"
      class="block"
    >
      <UCard class="hover:bg-gray-50 transition cursor-pointer">
        <div class="flex justify-between items-start">
          <div>
            <UBadge :color="topic.isResolved ? 'error' : 'success'">
              {{ STATUS_LABELS[topic.isResolved] }}
            </UBadge>
            <p class="font-semibold">{{ topic.title }}</p>
            <p class="text-sm text-gray-500">{{ topic.description }}</p>
          </div>
          <div class="text-sm text-gray-400 text-right shrink-0 ml-4">
            <UAvatar />
            <p>{{ topic.username }}</p>
            <p>{{ new Date(topic.createdAt).toLocaleDateString() }}</p>
          </div>
        </div>
      </UCard>
    </NuxtLink>

    <UModal v-model:open="isOpen" title="New Thread">
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
  </div>
</template>
