import type { CollectionConfig } from 'payload'

export const Volunteers: CollectionConfig = {
  slug: 'volunteers',
  admin: {
    useAsTitle: 'name',
    defaultColumns: ['name', 'organization', 'edition', 'coordinator'],
  },
  fields: [
    {
      name: 'edition',
      type: 'relationship',
      relationTo: 'festival_editions',
      required: true,
      hasMany: false,
    },
    {
      name: 'name',
      type: 'text',
      required: true,
    },
    {
      name: 'photo',
      type: 'relationship',
      relationTo: 'media',
      required: false,
    },
    {
      name: 'organization',
      type: 'text',
      required: false,
    },
    {
      name: 'birthDate',
      type: 'date',
      required: false,
      admin: {
        date: {
          pickerAppearance: 'dayOnly',
          displayFormat: 'yyyy-MM-dd',
        },
      },
    },
    {
      name: 'phone',
      type: 'text',
      required: false,
    },
    {
      name: 'agreementDocument',
      type: 'relationship',
      relationTo: 'media',
      required: false,
    },
    {
      name: 'coordinator',
      type: 'relationship',
      relationTo: 'members',
      required: false,
      hasMany: false,
    },
    {
      name: 'userAccount',
      type: 'relationship',
      relationTo: 'users',
      required: false,
      hasMany: false,
    },
  ],
  timestamps: true,
}
