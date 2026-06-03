<script setup lang="ts">
const route = useRoute();
const { data: profile, refresh } = await useFetch(
  `/api/user/${route.params.id}`,
);

const { user, loggedIn } = useUserSession();

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

// const isOwnProfile = false;

const avatarFile = ref<File | null>(null);
const avatarPreview = ref<string | null>(profile.value?.avatarUrl ?? null);

const isOwnProfile = computed(() => {
  if (!loggedIn.value) return false;
  return user.value?.id === profile.value?.id;
});

function onAvatarChange(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0];
  if (!file) return;
  avatarFile.value = file;
  avatarPreview.value = URL.createObjectURL(file);
}

async function uploadAvatar() {
  if (!avatarFile.value) return;
  const formData = new FormData();
  formData.append("avatar", avatarFile.value);
  await $fetch("/api/user/avatar", { method: "POST", body: formData });
}

async function updateProfile() {
  await uploadAvatar();
  await $fetch(`/api/user/${route.params.id}`, {
    method: "PATCH",
    body: state,
  });
  await refresh();
}
</script>

<template>
  <div class="p-6 max-w-xl space-y-4">
    <h1 class="text-2xl font-bold">Profile</h1>

    <div class="flex items-center gap-4">
      <UAvatar :src="avatarPreview ?? undefined" size="xl" />
      <label class="cursor-pointer">
        <UButton v-if="isOwnProfile" as="span">Change Photo</UButton>
        <input
          type="file"
          accept="image/*"
          class="hidden"
          @change="onAvatarChange"
        />
      </label>
    </div>

    <UForm :state="state">
      <div class="space-y-4">
        <UFormField label="Email" name="email">
          <UInput
            v-model="state.email"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <UFormField label="Username" name="username">
          <UInput
            v-model="state.username"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <div class="flex gap-4">
          <UFormField label="First Name" name="firstName" class="flex-1">
            <UInput
              v-model="state.firstName"
              class="w-full"
              :disabled="!isOwnProfile"
            />
          </UFormField>
          <UFormField label="Last Name" name="lastName" class="flex-1">
            <UInput
              v-model="state.lastName"
              class="w-full"
              :disabled="!isOwnProfile"
            />
          </UFormField>
        </div>
        <UFormField
          label="Date of Birth"
          name="dateOfBirth"
          :disabled="!isOwnProfile"
        >
          <UInput
            v-model="state.dateOfBirth"
            type="date"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <UFormField label="Home Country" name="homeCountry">
          <UInput
            v-model="state.homeCountry"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <UFormField label="Institution" name="institution">
          <UInput
            v-model="state.institution"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <UFormField label="Specialty" name="specialty">
          <UInput
            v-model="state.specialty"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <UFormField label="Role" name="role">
          <UInput v-model="state.role" class="w-full" disabled />
        </UFormField>
        <UFormField label="Verification Document" name="verificationDocument">
          <UInput
            v-model="state.verificationDocument"
            class="w-full"
            :disabled="!isOwnProfile"
          />
        </UFormField>
        <div class="flex justify-end">
          <UButton v-if="isOwnProfile" @click="updateProfile" type="submit"
            >Save</UButton
          >
        </div>
      </div>
    </UForm>
  </div>
</template>
