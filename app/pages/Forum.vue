<script setup lang="ts">
const isOpen = ref(false);
const state = reactive({ name: "", description: "" });

const { data: categories, refresh } = await useFetch("/api/categories");

async function createCategory() {
  await $fetch("/api/categories", { method: "POST", body: state });
  state.name = "";
  state.description = "";
  isOpen.value = false;
  refresh();
}
</script>

<template>
  <div class="p-6 space-y-4">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Categories</h1>
      <UButton @click="isOpen = true">New Category</UButton>
    </div>

    <NuxtLink
      v-for="category in categories"
      :key="category.id"
      :to="`/Threads?categoryId=${category.id}`"
      class="block"
    >
      <UCard class="hover:bg-gray-50 transition cursor-pointer">
        <div>
          <p class="font-semibold">{{ category.name }}</p>
          <p class="text-sm text-gray-500">{{ category.description }}</p>
        </div>
      </UCard>
    </NuxtLink>

    <UModal v-model:open="isOpen" title="Create New Category">
      <template #body>
        <div class="space-y-4">
          <UFormField label="Name" name="name">
            <UInput v-model="state.name" class="w-full" />
          </UFormField>
          <UFormField label="Description" name="description">
            <UInput v-model="state.description" class="w-full" />
          </UFormField>
          <div class="flex justify-end">
            <UButton @click="createCategory">Create</UButton>
          </div>
        </div>
      </template>
    </UModal>
  </div>
</template>
