<script setup lang="ts">
defineProps<{
  id: string;
  name: string;
  date: string;
  text: string;
}>();
</script>

<template>
  <div>
    <NuxtLink :to="`/topic/${id}`">
      <UCard color:secondary>
        <div class="flex h-20">
          <div class="flex flex-col w-1/4 h-full">
            <UAvatar />
            <p>{{ name }}</p>
            <p>{{ date }}</p>
          </div>
          <div class="w-3/4 h-full">
            <div>{{ text }}</div>
          </div>
        </div>
      </UCard>
    </NuxtLink>
  </div>
</template>
