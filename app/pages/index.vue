<script setup>
import Hero from "@/components/Hero.vue";

const { loggedIn, user } = useUserSession()
</script>

<template>
  <Hero />
  <div class="text-center mt-4 text-black dark:text-white">
    <p>loggedIn: {{ loggedIn }}</p>
    <p v-if="loggedIn">Logged in as: {{ user?.email }}</p>
    <p v-else>Not logged in</p>
  </div>
</template>
