<script setup>
import Hero from "@/components/Hero.vue";

const { loggedIn, user, fetch: fetchSession } = useUserSession();
</script>

<template>
  <Hero />
</template>
