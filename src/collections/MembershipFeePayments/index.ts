import type { CollectionConfig } from 'payload'

export const MembershipFeePayments: CollectionConfig = {
  slug: 'membership_fee_payments',
  admin: {
    useAsTitle: 'id',
  },
  fields: [
    {
      name: 'payment_amount',
      type: 'number',
      required: true,
      min: 0,
    },
    {
      name: 'payment_time',
      type: 'text',
      required: true,
    },
    {
      name: 'payer_email',
      type: 'text',
      required: true,
    },
    {
      name: 'on_behalf_of',
      type: 'relationship',
      relationTo: 'members',
      required: true,
    },
  ],
  timestamps: false,
}