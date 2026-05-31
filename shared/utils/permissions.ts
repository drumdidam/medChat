export type Permission =
  | "viewContent"
  | "createTopic"
  | "editOwnContent"
  | "deleteOwnContent"
  | "deleteAnyContent"
  | "banUsers"
  | "markResolved"
  | "assignRoles"
  | "systemConfig";

export type Permissions = Record<Permission, boolean>;

export function hasPermission(
  permissions: Permissions | null | undefined,
  permission: Permission
): boolean {
  if (!permissions) return false;
  return permissions[permission] === true;
}
