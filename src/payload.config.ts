// storage-adapter-import-placeholder
import { sqliteAdapter } from '@payloadcms/db-sqlite'

import sharp from 'sharp' // sharp-import
import path from 'path'
import { buildConfig, PayloadRequest } from 'payload'
import { fileURLToPath } from 'url'

import { Users } from './collections/Users'
import { Roles } from './collections/Roles'
import { UserRoles } from './collections/UserRoles'
import { Members } from './collections/Members'
import { MembershipVotingType } from './collections/MembershipVotingType'
import { VotingMemberType } from './collections/VotingMemberType'
import { MembershipFeePayments } from './collections/MembershipFeePayments'
import { UserMembership } from './collections/UserMembership'
import { Media } from './collections/Media'
import { Initiatives } from './collections/Initiatives'
import { Posts } from './collections/Posts'
import { Categories } from './collections/Categories'
import { Meetings } from './collections/Meetings'
import { Ninjas } from './collections/Ninjas'
import { Mentors } from './collections/Mentors'
import { FestivalEditions } from './collections/FestivalEditions'
import { FestivalSections } from './collections/FestivalSections'
import { Volunteers } from './collections/Volunteers'
import { Locations } from './collections/Locations'
import { LocationPhotos } from './collections/LocationPhotos'
import { Guests } from './collections/Guests'
import { Activities } from './collections/Activities'
import { ActivityGuests } from './collections/ActivityGuests'
import { Schedule } from './collections/Schedule'
// import { Footer } from './Footer/config'
// import { Header } from './Header/config'
import { plugins } from './plugins'
import { defaultLexical } from '@/fields/defaultLexical'
import { getServerSideURL } from './utilities/getURL'
import { en } from '@payloadcms/translations/languages/en'
import { ro } from '@payloadcms/translations/languages/ro'

const filename = fileURLToPath(import.meta.url)
const dirname = path.dirname(filename)

export default buildConfig({
  admin: {
    components: {
      beforeLogin: ['@/components/BeforeLogin'],
      beforeDashboard: ['@/components/BeforeDashboard'],
    },
    importMap: {
      baseDir: path.resolve(dirname),
    },
    user: Users.slug,
    livePreview: {
      breakpoints: [
        {
          label: 'Mobile',
          name: 'mobile',
          width: 375,
          height: 667,
        },
        {
          label: 'Tablet',
          name: 'tablet',
          width: 768,
          height: 1024,
        },
        {
          label: 'Desktop',
          name: 'desktop',
          width: 1440,
          height: 900,
        },
      ],
    },
  },
  editor: defaultLexical,
  db: sqliteAdapter({
    client: {
      url: process.env.DATABASE_URI || '',
    },
    push: false,
  }),
  collections: [
    Users,
    Roles,
    UserRoles,
    Members,
    MembershipVotingType,
    VotingMemberType,
    MembershipFeePayments,
    UserMembership,
    Media,
    Initiatives,
    Posts,
    Categories,
    Meetings,
    Ninjas,
    Mentors,
    FestivalEditions,
    FestivalSections,
    Volunteers,
    Locations,
    LocationPhotos,
    Guests,
    Activities,
    ActivityGuests,
    Schedule,
  ],
  cors: [getServerSideURL()].filter(Boolean),
  globals: [],
  plugins: [...plugins],
  i18n: {
    fallbackLanguage: 'en',
    supportedLanguages: { en, ro },
  },
  secret: process.env.PAYLOAD_SECRET,
  sharp,
  typescript: {
    outputFile: path.resolve(dirname, 'payload-types.ts'),
  },
  jobs: {
    access: {
      run: ({ req }: { req: PayloadRequest }): boolean => {
        if (req.user) return true
        const authHeader = req.headers.get('authorization')
        return authHeader === `Bearer ${process.env.CRON_SECRET}`
      },
    },
    tasks: [],
  },
})
