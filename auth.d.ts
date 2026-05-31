import type { Permissions } from "#shared/utils/permissions";

declare module "#auth-utils" {
  interface User {
    id: string;
    email: string;
    username: string;
    role: string;
    permissions: Permissions;
  }
}

export {};
