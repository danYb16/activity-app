import type { CollectionConfig } from 'payload'

export const MembershipVotingType: CollectionConfig = {
  slug: 'membership_voting_type',
  admin: {
    hidden: true,
  },
  fields: [
    {
      name: 'member',
      type: 'relationship',
      relationTo: 'members',
      required: true,
    },
    {
      name: 'voting_type',
      type: 'relationship',
      relationTo: 'voting_member_type',
      required: true,
    },
  ],
  timestamps: false,
}