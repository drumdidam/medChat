<script setup lang="ts">
import type { NavigationMenuItem } from "@nuxt/ui";

const { loggedIn, clear, user } = useUserSession();
const router = useRouter();

const { data: profile } = useFetch(() => `/api/user/${user.value?.id}`, {
  watch: [user],
  immediate: loggedIn.value,
});

async function logout() {
  await clear();
  router.push("/auth/login");
}

const items = computed(() => [
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
  ...(!loggedIn.value
    ? [
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
      ]
    : []),
]);
</script>

<template>
  <div class="grid grid-cols-3 items-center px-6 py-2">
    <NuxtLink to="/">
      <div class="text-lg font-bold">medChat</div>
    </NuxtLink>
    <UNavigationMenu :items="items" class="justify-self-center" />
    <div class="flex justify-end items-center gap-3">
      <UButton v-if="loggedIn" variant="ghost" @click="logout">Logout</UButton>
      <NuxtLink v-if="loggedIn" :to="`/user/${user?.id}`">
        <UAvatar :src="profile?.avatarUrl ?? undefined" :alt="user?.email" />
      </NuxtLink>
    </div>
  </div>
</template>
