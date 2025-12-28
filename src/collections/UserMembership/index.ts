import type { CollectionConfig } from 'payload'

export const UserMembership: CollectionConfig = {
  slug: 'user_membership',
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
      name: 'membership',
      type: 'relationship',
      relationTo: 'members',
      required: true,
      unique: true,
    },
  ],
  timestamps: false,
}