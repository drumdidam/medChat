<script setup lang="ts">
const router = useRouter();
const searchTerm = ref("");

const { data, status } = useAsyncData(
  "search",
  () => $fetch("/api/search", { query: { q: searchTerm.value } }),
  { watch: [searchTerm], immediate: false }
);

const groups = computed(() => {
  if (!data.value?.length) return [];
  return [
    {
      id: "topics",
      label: "Threads",
      filter: false,
      items: data.value.map((t) => ({
        label: t.title,
        suffix: t.categoryName ?? undefined,
        icon: "i-heroicons-chat-bubble-left-right",
        to: `/forum/${t.id}`,
      })),
    },
  ];
});
</script>

<template>
  <Hero />
  <div class="w-full px-6 py-6 max-w-3xl mx-auto">
    <UCommandPalette
      v-model:search-term="searchTerm"
      :groups="groups"
      :loading="status === 'pending'"
      placeholder="Search threads, topics..."
      @update:model-value="(val) => val?.to && router.push(val.to)"
    />
  </div>
</template>
