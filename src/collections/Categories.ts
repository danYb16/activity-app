import type { CollectionConfig } from 'payload'

import { anyone } from '../access/anyone'
import { authenticated } from '../access/authenticated'
import { slugField } from 'payload'

export const Categories: CollectionConfig = {
  slug: 'categories',
  labels: {
    singular: {
      en: 'Category',
      ro: 'Categorie',
    },
    plural: {
      en: 'Categories',
      ro: 'Categorii',
    },
  },
  access: {
    create: authenticated,
    delete: authenticated,
    read: anyone,
    update: authenticated,
  },
  admin: {
    useAsTitle: 'title',
  },
  fields: [
    {
      name: 'title',
      label: {
        en: 'Title',
        ro: 'Titlu',
      },
      type: 'text',
      required: true,
    },
    slugField({
      position: undefined,
    }),
  ],
}
