<script setup lang="ts">
const route = useRoute();
const { data: profile } = await useFetch(`/api/user/${route.params.id}`);

console.log(profile);

const state = reactive({
  email: profile.value?.email ?? "",
  username: profile.value?.username ?? "",
  firstName: profile.value?.firstName ?? "",
  lastName: profile.value?.lastName ?? "",
  dateOfBirth: profile.value?.dateOfBirth ?? "",
  homeCountry: profile.value?.homeCountry ?? "",
  institution: profile.value?.institution ?? "",
  specialty: profile.value?.specialty ?? "",
  verificationDocument: profile.value?.verificationDocument ?? "",
  role: profile.value?.roleName ?? "",
});
</script>

<template>
  <div class="p-6 max-w-xl space-y-4">
    <h1 class="text-2xl font-bold">Profile</h1>
    <UForm :state="state">
      <div class="space-y-4">
        <UFormField label="Email" name="email">
          <UInput v-model="state.email" class="w-full" />
        </UFormField>
        <UFormField label="Username" name="username">
          <UInput v-model="state.username" class="w-full" />
        </UFormField>
        <div class="flex gap-4">
          <UFormField label="First Name" name="firstName" class="flex-1">
            <UInput v-model="state.firstName" class="w-full" />
          </UFormField>
          <UFormField label="Last Name" name="lastName" class="flex-1">
            <UInput v-model="state.lastName" class="w-full" />
          </UFormField>
        </div>
        <UFormField label="Date of Birth" name="dateOfBirth">
          <UInput v-model="state.dateOfBirth" type="date" class="w-full" />
        </UFormField>
        <UFormField label="Home Country" name="homeCountry">
          <UInput v-model="state.homeCountry" class="w-full" />
        </UFormField>
        <UFormField label="Institution" name="institution">
          <UInput v-model="state.institution" class="w-full" />
        </UFormField>
        <UFormField label="Specialty" name="specialty">
          <UInput v-model="state.specialty" class="w-full" />
        </UFormField>
        <UFormField label="Role" name="role">
          <UInput v-model="state.role" class="w-full" disabled />
        </UFormField>
        <UFormField label="Verification Document" name="verificationDocument">
          <UInput v-model="state.verificationDocument" class="w-full" />
        </UFormField>
        <div class="flex justify-end">
          <UButton type="submit">Save</UButton>
        </div>
      </div>
    </UForm>
  </div>
</template>
