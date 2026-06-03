<script setup lang="ts">
const route = useRoute();

const { data, error } = await useFetch("/api/auth/verify", {
  query: { token: route.query.token },
});

let timer: ReturnType<typeof setTimeout> | null = null;

if (data.value) {
  timer = setTimeout(() => navigateTo("/auth/login"), 3000);
}

onBeforeUnmount(() => {
  if (timer) clearTimeout(timer);
});
</script>

<template>
  <div class="verify-page">
    <div v-if="error">
      <h2>Error</h2>
      <p>{{ error.message }}</p>
    </div>

    <div v-else>
      <h2>E-Mail verified</h2>
      <p>You will be continued in 3 seconds ...</p>
    </div>
  </div>
</template>
