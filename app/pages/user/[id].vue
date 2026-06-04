<script setup lang="ts">
const route = useRoute();
const router = useRouter();
const { data: profile, refresh } = await useFetch(
  `/api/user/${route.params.id}`,
);

const { user, loggedIn, clear } = useUserSession();

const state = reactive({
  email: profile.value?.email ?? "",
  username: profile.value?.username ?? "",
  firstName: profile.value?.firstName ?? "",
  lastName: profile.value?.lastName ?? "",
  dateOfBirth: profile.value?.dateOfBirth ?? "",
  homeCountry: profile.value?.homeCountry ?? "",
  institution: profile.value?.institution ?? "",
  specialty: profile.value?.specialty ?? "",
  role: profile.value?.roleName ?? "",
});

// const isOwnProfile = false;

const avatarFile = ref<File | null>(null);
const documentFile = ref<File | null>(null);
const avatarPreview = ref<string | null>(profile.value?.avatarUrl ?? null);
const documentName = ref<string | null>(null);
const deletePassword = ref("");
const isDeleteOpen = ref(false);

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

function onDocumentChange(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0];
  if (!file) return;
  documentFile.value = file;
  documentName.value = file.name;
}

async function uploadAvatar() {
  if (!avatarFile.value) return;
  const formData = new FormData();
  formData.append("avatar", avatarFile.value);
  await $fetch("/api/user/avatar", { method: "POST", body: formData });
}

async function uploadDocument() {
  if (!documentFile.value) return;
  const formData = new FormData();
  formData.append("document", documentFile.value);
  await $fetch("/api/user/document", { method: "POST", body: formData });
}

async function updateProfile() {
  await uploadAvatar();
  await uploadDocument();
  await $fetch(`/api/user/${route.params.id}`, {
    method: "PATCH",
    body: state,
  });
  await refresh();
}

async function deleteUser() {
  await $fetch(`/api/user/${route.params.id}`, {
    method: "DELETE",
    body: { password: deletePassword.value },
  });
  refresh();
  isDeleteOpen.value = false;
  await clear();
  await router.push("/");
}
</script>

<template>
  <div class="flex justify-center p-6">
    <div class="w-full max-w-xl space-y-4">
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
          <UFormField v-if="isOwnProfile" label="Email" name="email">
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
            v-if="isOwnProfile"
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
          <UFormField
            v-if="isOwnProfile"
            label="Verification Document"
            name="verificationDocument"
          >
            <label class="cursor-pointer">
              <UButton as="span">{{
                documentName ??
                (profile?.verificationDocument
                  ? "Replace Document"
                  : "Upload Document")
              }}</UButton>
              <input
                type="file"
                accept=".pdf,image/*"
                class="hidden"
                @change="onDocumentChange"
              />
            </label>
            <UButton
              v-if="profile?.verificationDocument"
              to="/api/user/document"
              target="_blank"
              as="a"
              >View Document</UButton
            >
          </UFormField>
          <div class="grid grid-cols-2">
            <div class="flex justify-center items-center">
              <UButton
                v-if="isOwnProfile"
                @click="isDeleteOpen = true"
                color="error"
                >Delete</UButton
              >
            </div>
            <div class="flex justify-center items-center">
              <UButton v-if="isOwnProfile" @click="updateProfile" type="submit"
                >Save</UButton
              >
            </div>
          </div>
        </div>
      </UForm>
    </div>
  </div>

  <UModal
    v-model:open="isDeleteOpen"
    title="Are you sure you want to delete your Profile?"
  >
    <template #body>
      <div class="flex justify-center items-center space-x-4">
        <UFormField label="Password" name="password" class="w-full">
          <UInput v-model="deletePassword" type="password" class="w-full" />
        </UFormField>
        <UButton @click="deleteUser" color="error">Yes</UButton>
        <UButton @click="isDeleteOpen = false">Go Back</UButton>
      </div>
    </template>
  </UModal>
</template>
