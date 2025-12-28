import type { CollectionConfig } from 'payload'

export const UserRoles: CollectionConfig = {
  slug: 'user_roles',
  admin: {
    hidden: true,
  },
  fields: [
    {
      name: 'user',
      type: 'relationship',
      relationTo: 'users',
      required: true,
    },
    {
      name: 'role',
      type: 'relationship',
      relationTo: 'roles',
      required: true,
    },
    {
      name: 'assigned_at',
      type: 'date',
      required: true,
      defaultValue: () => new Date().toISOString(),
      admin: {
        date: {
          displayFormat: 'yyyy-MM-dd HH:mm:ss',
        },
      },
    },
  ],
  timestamps: false,
}