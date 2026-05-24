<script setup lang="ts">
import type { NavigationMenuItem } from "@nuxt/ui";

const items = [
  {
    label: "Home",
    icon: "i-heroicons-home",
    to: "/",
  },
  {
    label: "Forum",
    icon: "i-heroicons-chat-bubble-left-right",
    to: "/forum",
  },
  {
    label: "Search",
    icon: "i-heroicons-magnifying-glass",
    to: "/search",
  },
  {
    label: "Sign In",
    icon: "i-heroicons-arrow-right-end-on-rectangle",
    to: "/auth/login",
  },
  {
    label: "Sign Up",
    icon: "i-heroicons-user-plus",
    to: "/auth/register",
  },
];
</script>

<template>
  <UNavigationMenu :items="items" />
</template>
