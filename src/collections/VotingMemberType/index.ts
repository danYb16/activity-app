import type { CollectionConfig } from 'payload'

export const VotingMemberType: CollectionConfig = {
  slug: 'voting_member_type',
  admin: {
    useAsTitle: 'type_name',
  },
  fields: [
    {
      name: 'type_name',
      type: 'select',
      required: true,
      options: [
        { label: 'Honorary', value: 'honorary' },
        { label: 'Founder', value: 'founder' },
      ],
    },
  ],
  timestamps: false,
}