<script setup lang="ts">
import * as v from "valibot";
import type { FormSubmitEvent } from "@nuxt/ui";

const schema = v.object({
  email: v.pipe(v.string(), v.email("Invalid email")),
  password: v.pipe(v.string(), v.minLength(8, "Must be at least 8 characters")),
});

type Schema = v.InferOutput<typeof schema>;

const state = reactive({ email: "", password: "" });
const toast = useToast();
const router = useRouter();

async function onSubmit(event: FormSubmitEvent<Schema>) {
  try {
    await $fetch("/auth/login", {
      method: "POST",
      body: event.data,
    });
    router.push("/");
  } catch {
    toast.add({ title: "Error", description: "Invalid email or password.", color: "error" });
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center">
    <UCard color="neutral" class="w-full max-w-sm">
      <div class="text-center text-xl font-semibold mb-4">Welcome back</div>
      <UForm :schema="schema" :state="state" class="space-y-4 w-full" @submit="onSubmit">
        <UFormField label="Email" name="email" class="w-full">
          <UInput v-model="state.email" class="w-full" />
        </UFormField>

        <UFormField label="Password" name="password" class="w-full">
          <UInput v-model="state.password" type="password" class="w-full" />
        </UFormField>

        <div class="flex justify-center">
          <UButton type="submit">Sign in</UButton>
        </div>

        <div class="text-center text-sm">
          Don't have an account?
          <NuxtLink to="/auth/register" class="underline">Register</NuxtLink>
        </div>
      </UForm>
    </UCard>
  </div>
</template>
