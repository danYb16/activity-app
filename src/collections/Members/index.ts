import type { CollectionConfig } from 'payload'

export const Members: CollectionConfig = {
  slug: 'members',
  admin: {
    useAsTitle: 'id',
  },
  fields: [
    {
      name: 'membership_type',
      type: 'select',
      options: [
        { label: 'Aspiring', value: 'aspiring' },
        { label: 'Voting', value: 'voting' },
      ],
    },
    {
      name: 'photo_path',
      type: 'text',
    },
  ],
  timestamps: false,
}