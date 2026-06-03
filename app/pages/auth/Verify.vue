<script setup lang="ts">
const route = useRoute();
const router = useRouter();

const { data, error } = await useFetch("/api/auth/verify", {
  query: { token: route.query.token },
});

if (data.value) {
  setTimeout(() => router.push("/login"), 3000);
}
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
