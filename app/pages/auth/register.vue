<script setup lang="ts">
import * as v from "valibot";
import type { FormSubmitEvent } from "@nuxt/ui";

const schema = v.pipe(
  v.object({
    username: v.pipe(
      v.string(),
      v.minLength(3, "Must be at least 3 characters"),
    ),
    email: v.pipe(v.string(), v.email("Invalid email")),
    password: v.pipe(
      v.string(),
      v.minLength(8, "Must be at least 8 characters"),
    ),
    passwordRepeat: v.string(),
    //specialty: v.optional(v.string()),
    //verificationDocument: v.optional(v.string()),
  }),

  v.forward(
    v.check((data) => data.password === data.passwordRepeat, "Passwords do not match"),
    ["passwordRepeat"]
  ),
);

type Schema = v.InferOutput<typeof schema>;

const state = reactive({
  username: "",
  email: "",
  password: "",
  passwordRepeat: "",
  //specialty: "",
  //verificationDocument: "",
});
const toast = useToast();
const router = useRouter();
const { fetch: fetchSession, user } = useUserSession();

async function onSubmit(event: FormSubmitEvent<Schema>) {
  try {
    await $fetch("/auth/register", {
      method: "POST",
      body: event.data,
    });
    await fetchSession();
    router.push(`/user/${user.value?.id}`);
  } catch {
    toast.add({
      title: "Error",
      description: "Registration failed.",
      color: "error",
    });
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center">
    <UCard color="neutral" class="w-full max-w-sm">
      <div class="text-center text-xl font-semibold mb-4">Create account</div>
      <UForm
        :schema="schema"
        :state="state"
        class="space-y-4 w-full"
        @submit="onSubmit"
      >
        <UFormField label="Username" name="username" class="w-full">
          <UInput v-model="state.username" class="w-full" />
        </UFormField>

        <UFormField label="Email" name="email" class="w-full">
          <UInput v-model="state.email" class="w-full" />
        </UFormField>

        <UFormField label="Password" name="password" class="w-full">
          <UInput v-model="state.password" type="password" class="w-full" />
        </UFormField>
        <UFormField
          label="Repeat Password"
          name="passwordRepeat"
          class="w-full"
        >
          <UInput
            v-model="state.passwordRepeat"
            type="password"
            class="w-full"
          />
        </UFormField>
        <!-- <UFormField label="Specialty" name="specialty" class="w-full"> -->
        <!--   <UInput v-model="state.specialty" class="w-full" placeholder="e.g. Cardiology" /> -->
        <!-- </UFormField> -->
        <!---->
        <!-- <UFormField label="Verification Document" name="verificationDocument" class="w-full"> -->
        <!--   <UInput v-model="state.verificationDocument" class="w-full" placeholder="Document URL or ID" /> -->
        <!-- </UFormField> -->
        <!---->
        <div class="flex justify-center">
          <UButton type="submit">Register</UButton>
        </div>

        <div class="text-center text-sm">
          Already have an account?
          <NuxtLink to="/auth/login" class="underline">Sign in</NuxtLink>
        </div>
      </UForm>
    </UCard>
  </div>
</template>
