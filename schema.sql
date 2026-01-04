CREATE TABLE `users_sessions` (
  	`_order` integer NOT NULL,
  	`_parent_id` integer NOT NULL,
  	`id` text PRIMARY KEY NOT NULL,
  	`created_at` text,
  	`expires_at` text NOT NULL,
  	FOREIGN KEY (`_parent_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `users_sessions_order_idx` ON `users_sessions` (`_order`);
CREATE INDEX `users_sessions_parent_id_idx` ON `users_sessions` (`_parent_id`);
CREATE TABLE `users` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`name` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`email` text NOT NULL,
  	`reset_password_token` text,
  	`reset_password_expiration` text,
  	`salt` text,
  	`hash` text,
  	`login_attempts` numeric DEFAULT 0,
  	`lock_until` text
  );
CREATE INDEX `users_updated_at_idx` ON `users` (`updated_at`);
CREATE INDEX `users_created_at_idx` ON `users` (`created_at`);
CREATE UNIQUE INDEX `users_email_idx` ON `users` (`email`);
CREATE TABLE `roles` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`name` text NOT NULL
  );
CREATE UNIQUE INDEX `roles_name_idx` ON `roles` (`name`);
CREATE TABLE `user_roles` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`user_id` integer NOT NULL,
  	`role_id` integer NOT NULL,
  	`assigned_at` text NOT NULL,
  	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `user_roles_user_idx` ON `user_roles` (`user_id`);
CREATE INDEX `user_roles_role_idx` ON `user_roles` (`role_id`);
CREATE TABLE `members` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`membership_type` text,
  	`photo_path` text
  );
CREATE TABLE `membership_voting_type` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`member_id` integer NOT NULL,
  	`voting_type_id` integer NOT NULL,
  	FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`voting_type_id`) REFERENCES `voting_member_type`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `membership_voting_type_member_idx` ON `membership_voting_type` (`member_id`);
CREATE INDEX `membership_voting_type_voting_type_idx` ON `membership_voting_type` (`voting_type_id`);
CREATE TABLE `voting_member_type` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`type_name` text NOT NULL
  );
CREATE TABLE `membership_fee_payments` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`payment_amount` numeric NOT NULL,
  	`payment_time` text NOT NULL,
  	`payer_email` text NOT NULL,
  	`on_behalf_of_id` integer NOT NULL,
  	FOREIGN KEY (`on_behalf_of_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `membership_fee_payments_on_behalf_of_idx` ON `membership_fee_payments` (`on_behalf_of_id`);
CREATE TABLE `user_membership` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`user_id` integer NOT NULL,
  	`membership_id` integer NOT NULL,
  	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`membership_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `user_membership_user_idx` ON `user_membership` (`user_id`);
CREATE UNIQUE INDEX `user_membership_membership_idx` ON `user_membership` (`membership_id`);
CREATE TABLE `media` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`alt` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`url` text,
  	`thumbnail_u_r_l` text,
  	`filename` text,
  	`mime_type` text,
  	`filesize` numeric,
  	`width` numeric,
  	`height` numeric,
  	`focal_x` numeric,
  	`focal_y` numeric
  );
CREATE INDEX `media_updated_at_idx` ON `media` (`updated_at`);
CREATE INDEX `media_created_at_idx` ON `media` (`created_at`);
CREATE UNIQUE INDEX `media_filename_idx` ON `media` (`filename`);
CREATE TABLE `initiatives` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`title` text NOT NULL,
  	`description` text,
  	`image_id` integer,
  	`site_link` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`image_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `initiatives_image_idx` ON `initiatives` (`image_id`);
CREATE INDEX `initiatives_updated_at_idx` ON `initiatives` (`updated_at`);
CREATE INDEX `initiatives_created_at_idx` ON `initiatives` (`created_at`);
CREATE TABLE `posts_populated_authors` (
  	`_order` integer NOT NULL,
  	`_parent_id` integer NOT NULL,
  	`id` text PRIMARY KEY NOT NULL,
  	`name` text,
  	FOREIGN KEY (`_parent_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `posts_populated_authors_order_idx` ON `posts_populated_authors` (`_order`);
CREATE INDEX `posts_populated_authors_parent_id_idx` ON `posts_populated_authors` (`_parent_id`);
CREATE TABLE `posts` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`title` text,
  	`hero_image_id` integer,
  	`content` text,
  	`initiative_id` integer,
  	`meta_title` text,
  	`meta_image_id` integer,
  	`meta_description` text,
  	`published_at` text,
  	`generate_slug` integer DEFAULT true,
  	`slug` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`_status` text DEFAULT 'draft',
  	FOREIGN KEY (`hero_image_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`initiative_id`) REFERENCES `initiatives`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`meta_image_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `posts_hero_image_idx` ON `posts` (`hero_image_id`);
CREATE INDEX `posts_initiative_idx` ON `posts` (`initiative_id`);
CREATE INDEX `posts_meta_meta_image_idx` ON `posts` (`meta_image_id`);
CREATE UNIQUE INDEX `posts_slug_idx` ON `posts` (`slug`);
CREATE INDEX `posts_updated_at_idx` ON `posts` (`updated_at`);
CREATE INDEX `posts_created_at_idx` ON `posts` (`created_at`);
CREATE INDEX `posts__status_idx` ON `posts` (`_status`);
CREATE TABLE `posts_rels` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`order` integer,
  	`parent_id` integer NOT NULL,
  	`path` text NOT NULL,
  	`posts_id` integer,
  	`categories_id` integer,
  	`users_id` integer,
  	FOREIGN KEY (`parent_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`posts_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`categories_id`) REFERENCES `categories`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`users_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `posts_rels_order_idx` ON `posts_rels` (`order`);
CREATE INDEX `posts_rels_parent_idx` ON `posts_rels` (`parent_id`);
CREATE INDEX `posts_rels_path_idx` ON `posts_rels` (`path`);
CREATE INDEX `posts_rels_posts_id_idx` ON `posts_rels` (`posts_id`);
CREATE INDEX `posts_rels_categories_id_idx` ON `posts_rels` (`categories_id`);
CREATE INDEX `posts_rels_users_id_idx` ON `posts_rels` (`users_id`);
CREATE TABLE `_posts_v_version_populated_authors` (
  	`_order` integer NOT NULL,
  	`_parent_id` integer NOT NULL,
  	`id` integer PRIMARY KEY NOT NULL,
  	`_uuid` text,
  	`name` text,
  	FOREIGN KEY (`_parent_id`) REFERENCES `_posts_v`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `_posts_v_version_populated_authors_order_idx` ON `_posts_v_version_populated_authors` (`_order`);
CREATE INDEX `_posts_v_version_populated_authors_parent_id_idx` ON `_posts_v_version_populated_authors` (`_parent_id`);
CREATE TABLE `_posts_v` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`parent_id` integer,
  	`version_title` text,
  	`version_hero_image_id` integer,
  	`version_content` text,
  	`version_initiative_id` integer,
  	`version_meta_title` text,
  	`version_meta_image_id` integer,
  	`version_meta_description` text,
  	`version_published_at` text,
  	`version_generate_slug` integer DEFAULT true,
  	`version_slug` text,
  	`version_updated_at` text,
  	`version_created_at` text,
  	`version__status` text DEFAULT 'draft',
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`latest` integer,
  	`autosave` integer,
  	FOREIGN KEY (`parent_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`version_hero_image_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`version_initiative_id`) REFERENCES `initiatives`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`version_meta_image_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `_posts_v_parent_idx` ON `_posts_v` (`parent_id`);
CREATE INDEX `_posts_v_version_version_hero_image_idx` ON `_posts_v` (`version_hero_image_id`);
CREATE INDEX `_posts_v_version_version_initiative_idx` ON `_posts_v` (`version_initiative_id`);
CREATE INDEX `_posts_v_version_meta_version_meta_image_idx` ON `_posts_v` (`version_meta_image_id`);
CREATE INDEX `_posts_v_version_version_slug_idx` ON `_posts_v` (`version_slug`);
CREATE INDEX `_posts_v_version_version_updated_at_idx` ON `_posts_v` (`version_updated_at`);
CREATE INDEX `_posts_v_version_version_created_at_idx` ON `_posts_v` (`version_created_at`);
CREATE INDEX `_posts_v_version_version__status_idx` ON `_posts_v` (`version__status`);
CREATE INDEX `_posts_v_created_at_idx` ON `_posts_v` (`created_at`);
CREATE INDEX `_posts_v_updated_at_idx` ON `_posts_v` (`updated_at`);
CREATE INDEX `_posts_v_latest_idx` ON `_posts_v` (`latest`);
CREATE INDEX `_posts_v_autosave_idx` ON `_posts_v` (`autosave`);
CREATE TABLE `_posts_v_rels` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`order` integer,
  	`parent_id` integer NOT NULL,
  	`path` text NOT NULL,
  	`posts_id` integer,
  	`categories_id` integer,
  	`users_id` integer,
  	FOREIGN KEY (`parent_id`) REFERENCES `_posts_v`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`posts_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`categories_id`) REFERENCES `categories`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`users_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `_posts_v_rels_order_idx` ON `_posts_v_rels` (`order`);
CREATE INDEX `_posts_v_rels_parent_idx` ON `_posts_v_rels` (`parent_id`);
CREATE INDEX `_posts_v_rels_path_idx` ON `_posts_v_rels` (`path`);
CREATE INDEX `_posts_v_rels_posts_id_idx` ON `_posts_v_rels` (`posts_id`);
CREATE INDEX `_posts_v_rels_categories_id_idx` ON `_posts_v_rels` (`categories_id`);
CREATE INDEX `_posts_v_rels_users_id_idx` ON `_posts_v_rels` (`users_id`);
CREATE TABLE `categories` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`title` text NOT NULL,
  	`generate_slug` integer DEFAULT true,
  	`slug` text NOT NULL,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE UNIQUE INDEX `categories_slug_idx` ON `categories` (`slug`);
CREATE INDEX `categories_updated_at_idx` ON `categories` (`updated_at`);
CREATE INDEX `categories_created_at_idx` ON `categories` (`created_at`);
CREATE TABLE `meetings` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`title` text NOT NULL,
  	`date` text NOT NULL,
  	`venue` text NOT NULL,
  	`type` text DEFAULT 'workshop',
  	`workshop_topic` text,
  	`presenter_id` integer,
  	`discussion_agenda` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`presenter_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `meetings_presenter_idx` ON `meetings` (`presenter_id`);
CREATE INDEX `meetings_updated_at_idx` ON `meetings` (`updated_at`);
CREATE INDEX `meetings_created_at_idx` ON `meetings` (`created_at`);
CREATE TABLE `ninjas` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`child_name` text NOT NULL,
  	`age` numeric NOT NULL,
  	`useful_info` text,
  	`guardian_name` text NOT NULL,
  	`guardian_email` text NOT NULL,
  	`guardian_phone` text NOT NULL,
  	`safety_agreement` integer DEFAULT false NOT NULL,
  	`photo_release_agreement` integer DEFAULT false NOT NULL,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE INDEX `ninjas_updated_at_idx` ON `ninjas` (`updated_at`);
CREATE INDEX `ninjas_created_at_idx` ON `ninjas` (`created_at`);
CREATE TABLE `mentors` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`name` text NOT NULL,
  	`bio` text,
  	`photo_id` integer,
  	`user_account_id` integer,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`photo_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`user_account_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `mentors_photo_idx` ON `mentors` (`photo_id`);
CREATE INDEX `mentors_user_account_idx` ON `mentors` (`user_account_id`);
CREATE INDEX `mentors_updated_at_idx` ON `mentors` (`updated_at`);
CREATE INDEX `mentors_created_at_idx` ON `mentors` (`created_at`);
CREATE TABLE `festival_editions` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`year` numeric NOT NULL,
  	`title` text NOT NULL,
  	`theme` text,
  	`description` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE UNIQUE INDEX `festival_editions_year_idx` ON `festival_editions` (`year`);
CREATE INDEX `festival_editions_updated_at_idx` ON `festival_editions` (`updated_at`);
CREATE INDEX `festival_editions_created_at_idx` ON `festival_editions` (`created_at`);
CREATE TABLE `festival_sections` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`edition_id` integer NOT NULL,
  	`name` text NOT NULL,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`edition_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `festival_sections_edition_idx` ON `festival_sections` (`edition_id`);
CREATE INDEX `festival_sections_updated_at_idx` ON `festival_sections` (`updated_at`);
CREATE INDEX `festival_sections_created_at_idx` ON `festival_sections` (`created_at`);
CREATE TABLE `volunteers` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`edition_id` integer NOT NULL,
  	`name` text NOT NULL,
  	`photo_id` integer,
  	`organization` text,
  	`birth_date` text,
  	`phone` text,
  	`agreement_document_id` integer,
  	`coordinator_id` integer,
  	`user_account_id` integer,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`edition_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`photo_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`agreement_document_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`coordinator_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`user_account_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `volunteers_edition_idx` ON `volunteers` (`edition_id`);
CREATE INDEX `volunteers_photo_idx` ON `volunteers` (`photo_id`);
CREATE INDEX `volunteers_agreement_document_idx` ON `volunteers` (`agreement_document_id`);
CREATE INDEX `volunteers_coordinator_idx` ON `volunteers` (`coordinator_id`);
CREATE INDEX `volunteers_user_account_idx` ON `volunteers` (`user_account_id`);
CREATE INDEX `volunteers_updated_at_idx` ON `volunteers` (`updated_at`);
CREATE INDEX `volunteers_created_at_idx` ON `volunteers` (`created_at`);
CREATE TABLE `locations_facilities` (
  	`_order` integer NOT NULL,
  	`_parent_id` integer NOT NULL,
  	`id` text PRIMARY KEY NOT NULL,
  	`facility` text NOT NULL,
  	FOREIGN KEY (`_parent_id`) REFERENCES `locations`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `locations_facilities_order_idx` ON `locations_facilities` (`_order`);
CREATE INDEX `locations_facilities_parent_id_idx` ON `locations_facilities` (`_parent_id`);
CREATE TABLE `locations` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`edition_id` integer NOT NULL,
  	`name` text NOT NULL,
  	`address` text NOT NULL,
  	`coordinates` text,
  	`description` text,
  	`floor_plan_id` integer,
  	`capacity` numeric,
  	`coordinator_id` integer,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`edition_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`floor_plan_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`coordinator_id`) REFERENCES `volunteers`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `locations_edition_idx` ON `locations` (`edition_id`);
CREATE INDEX `locations_floor_plan_idx` ON `locations` (`floor_plan_id`);
CREATE INDEX `locations_coordinator_idx` ON `locations` (`coordinator_id`);
CREATE INDEX `locations_updated_at_idx` ON `locations` (`updated_at`);
CREATE INDEX `locations_created_at_idx` ON `locations` (`created_at`);
CREATE TABLE `location_photos` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`location_id` integer NOT NULL,
  	`photo_id` integer NOT NULL,
  	`order` numeric DEFAULT 0,
  	FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`photo_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `location_photos_location_idx` ON `location_photos` (`location_id`);
CREATE INDEX `location_photos_photo_idx` ON `location_photos` (`photo_id`);
CREATE TABLE `guests_guest_type` (
  	`order` integer NOT NULL,
  	`parent_id` integer NOT NULL,
  	`value` text,
  	`id` integer PRIMARY KEY NOT NULL,
  	FOREIGN KEY (`parent_id`) REFERENCES `guests`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `guests_guest_type_order_idx` ON `guests_guest_type` (`order`);
CREATE INDEX `guests_guest_type_parent_idx` ON `guests_guest_type` (`parent_id`);
CREATE TABLE `guests` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`edition_id` integer NOT NULL,
  	`name` text NOT NULL,
  	`organization` text,
  	`bio` text,
  	`photo_id` integer,
  	`website` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`edition_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`photo_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `guests_edition_idx` ON `guests` (`edition_id`);
CREATE INDEX `guests_photo_idx` ON `guests` (`photo_id`);
CREATE INDEX `guests_updated_at_idx` ON `guests` (`updated_at`);
CREATE INDEX `guests_created_at_idx` ON `guests` (`created_at`);
CREATE TABLE `activities_audience` (
  	`order` integer NOT NULL,
  	`parent_id` integer NOT NULL,
  	`value` text,
  	`id` integer PRIMARY KEY NOT NULL,
  	FOREIGN KEY (`parent_id`) REFERENCES `activities`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `activities_audience_order_idx` ON `activities_audience` (`order`);
CREATE INDEX `activities_audience_parent_idx` ON `activities_audience` (`parent_id`);
CREATE TABLE `activities` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`edition_id` integer NOT NULL,
  	`title` text NOT NULL,
  	`description` text,
  	`type` text NOT NULL,
  	`section_id` integer,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`edition_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`section_id`) REFERENCES `festival_sections`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `activities_edition_idx` ON `activities` (`edition_id`);
CREATE INDEX `activities_section_idx` ON `activities` (`section_id`);
CREATE INDEX `activities_updated_at_idx` ON `activities` (`updated_at`);
CREATE INDEX `activities_created_at_idx` ON `activities` (`created_at`);
CREATE TABLE `activity_guests` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`activity_id` integer NOT NULL,
  	`guest_id` integer NOT NULL,
  	`role` text,
  	FOREIGN KEY (`activity_id`) REFERENCES `activities`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`guest_id`) REFERENCES `guests`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `activity_guests_activity_idx` ON `activity_guests` (`activity_id`);
CREATE INDEX `activity_guests_guest_idx` ON `activity_guests` (`guest_id`);
CREATE TABLE `schedule` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`edition_id` integer NOT NULL,
  	`start_time` text NOT NULL,
  	`end_time` text NOT NULL,
  	`activity_id` integer NOT NULL,
  	`location_id` integer NOT NULL,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	FOREIGN KEY (`edition_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`activity_id`) REFERENCES `activities`(`id`) ON UPDATE no action ON DELETE set null,
  	FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`) ON UPDATE no action ON DELETE set null
  );
CREATE INDEX `schedule_edition_idx` ON `schedule` (`edition_id`);
CREATE INDEX `schedule_activity_idx` ON `schedule` (`activity_id`);
CREATE INDEX `schedule_location_idx` ON `schedule` (`location_id`);
CREATE INDEX `schedule_updated_at_idx` ON `schedule` (`updated_at`);
CREATE INDEX `schedule_created_at_idx` ON `schedule` (`created_at`);
CREATE TABLE `payload_kv` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`key` text NOT NULL,
  	`data` text NOT NULL
  );
CREATE UNIQUE INDEX `payload_kv_key_idx` ON `payload_kv` (`key`);
CREATE TABLE `payload_jobs_log` (
  	`_order` integer NOT NULL,
  	`_parent_id` integer NOT NULL,
  	`id` text PRIMARY KEY NOT NULL,
  	`executed_at` text NOT NULL,
  	`completed_at` text NOT NULL,
  	`task_slug` text NOT NULL,
  	`task_i_d` text NOT NULL,
  	`input` text,
  	`output` text,
  	`state` text NOT NULL,
  	`error` text,
  	FOREIGN KEY (`_parent_id`) REFERENCES `payload_jobs`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `payload_jobs_log_order_idx` ON `payload_jobs_log` (`_order`);
CREATE INDEX `payload_jobs_log_parent_id_idx` ON `payload_jobs_log` (`_parent_id`);
CREATE TABLE `payload_jobs` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`input` text,
  	`completed_at` text,
  	`total_tried` numeric DEFAULT 0,
  	`has_error` integer DEFAULT false,
  	`error` text,
  	`task_slug` text,
  	`queue` text DEFAULT 'default',
  	`wait_until` text,
  	`processing` integer DEFAULT false,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE INDEX `payload_jobs_completed_at_idx` ON `payload_jobs` (`completed_at`);
CREATE INDEX `payload_jobs_total_tried_idx` ON `payload_jobs` (`total_tried`);
CREATE INDEX `payload_jobs_has_error_idx` ON `payload_jobs` (`has_error`);
CREATE INDEX `payload_jobs_task_slug_idx` ON `payload_jobs` (`task_slug`);
CREATE INDEX `payload_jobs_queue_idx` ON `payload_jobs` (`queue`);
CREATE INDEX `payload_jobs_wait_until_idx` ON `payload_jobs` (`wait_until`);
CREATE INDEX `payload_jobs_processing_idx` ON `payload_jobs` (`processing`);
CREATE INDEX `payload_jobs_updated_at_idx` ON `payload_jobs` (`updated_at`);
CREATE INDEX `payload_jobs_created_at_idx` ON `payload_jobs` (`created_at`);
CREATE TABLE `payload_locked_documents` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`global_slug` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE INDEX `payload_locked_documents_global_slug_idx` ON `payload_locked_documents` (`global_slug`);
CREATE INDEX `payload_locked_documents_updated_at_idx` ON `payload_locked_documents` (`updated_at`);
CREATE INDEX `payload_locked_documents_created_at_idx` ON `payload_locked_documents` (`created_at`);
CREATE TABLE `payload_locked_documents_rels` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`order` integer,
  	`parent_id` integer NOT NULL,
  	`path` text NOT NULL,
  	`users_id` integer,
  	`roles_id` integer,
  	`user_roles_id` integer,
  	`members_id` integer,
  	`membership_voting_type_id` integer,
  	`voting_member_type_id` integer,
  	`membership_fee_payments_id` integer,
  	`user_membership_id` integer,
  	`media_id` integer,
  	`initiatives_id` integer,
  	`posts_id` integer,
  	`categories_id` integer,
  	`meetings_id` integer,
  	`ninjas_id` integer,
  	`mentors_id` integer,
  	`festival_editions_id` integer,
  	`festival_sections_id` integer,
  	`volunteers_id` integer,
  	`locations_id` integer,
  	`location_photos_id` integer,
  	`guests_id` integer,
  	`activities_id` integer,
  	`activity_guests_id` integer,
  	`schedule_id` integer,
  	FOREIGN KEY (`parent_id`) REFERENCES `payload_locked_documents`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`users_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`roles_id`) REFERENCES `roles`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`user_roles_id`) REFERENCES `user_roles`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`members_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`membership_voting_type_id`) REFERENCES `membership_voting_type`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`voting_member_type_id`) REFERENCES `voting_member_type`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`membership_fee_payments_id`) REFERENCES `membership_fee_payments`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`user_membership_id`) REFERENCES `user_membership`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`media_id`) REFERENCES `media`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`initiatives_id`) REFERENCES `initiatives`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`posts_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`categories_id`) REFERENCES `categories`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`meetings_id`) REFERENCES `meetings`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`ninjas_id`) REFERENCES `ninjas`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`mentors_id`) REFERENCES `mentors`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`festival_editions_id`) REFERENCES `festival_editions`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`festival_sections_id`) REFERENCES `festival_sections`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`volunteers_id`) REFERENCES `volunteers`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`locations_id`) REFERENCES `locations`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`location_photos_id`) REFERENCES `location_photos`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`guests_id`) REFERENCES `guests`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`activities_id`) REFERENCES `activities`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`activity_guests_id`) REFERENCES `activity_guests`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `payload_locked_documents_rels_order_idx` ON `payload_locked_documents_rels` (`order`);
CREATE INDEX `payload_locked_documents_rels_parent_idx` ON `payload_locked_documents_rels` (`parent_id`);
CREATE INDEX `payload_locked_documents_rels_path_idx` ON `payload_locked_documents_rels` (`path`);
CREATE INDEX `payload_locked_documents_rels_users_id_idx` ON `payload_locked_documents_rels` (`users_id`);
CREATE INDEX `payload_locked_documents_rels_roles_id_idx` ON `payload_locked_documents_rels` (`roles_id`);
CREATE INDEX `payload_locked_documents_rels_user_roles_id_idx` ON `payload_locked_documents_rels` (`user_roles_id`);
CREATE INDEX `payload_locked_documents_rels_members_id_idx` ON `payload_locked_documents_rels` (`members_id`);
CREATE INDEX `payload_locked_documents_rels_membership_voting_type_id_idx` ON `payload_locked_documents_rels` (`membership_voting_type_id`);
CREATE INDEX `payload_locked_documents_rels_voting_member_type_id_idx` ON `payload_locked_documents_rels` (`voting_member_type_id`);
CREATE INDEX `payload_locked_documents_rels_membership_fee_payments_id_idx` ON `payload_locked_documents_rels` (`membership_fee_payments_id`);
CREATE INDEX `payload_locked_documents_rels_user_membership_id_idx` ON `payload_locked_documents_rels` (`user_membership_id`);
CREATE INDEX `payload_locked_documents_rels_media_id_idx` ON `payload_locked_documents_rels` (`media_id`);
CREATE INDEX `payload_locked_documents_rels_initiatives_id_idx` ON `payload_locked_documents_rels` (`initiatives_id`);
CREATE INDEX `payload_locked_documents_rels_posts_id_idx` ON `payload_locked_documents_rels` (`posts_id`);
CREATE INDEX `payload_locked_documents_rels_categories_id_idx` ON `payload_locked_documents_rels` (`categories_id`);
CREATE INDEX `payload_locked_documents_rels_meetings_id_idx` ON `payload_locked_documents_rels` (`meetings_id`);
CREATE INDEX `payload_locked_documents_rels_ninjas_id_idx` ON `payload_locked_documents_rels` (`ninjas_id`);
CREATE INDEX `payload_locked_documents_rels_mentors_id_idx` ON `payload_locked_documents_rels` (`mentors_id`);
CREATE INDEX `payload_locked_documents_rels_festival_editions_id_idx` ON `payload_locked_documents_rels` (`festival_editions_id`);
CREATE INDEX `payload_locked_documents_rels_festival_sections_id_idx` ON `payload_locked_documents_rels` (`festival_sections_id`);
CREATE INDEX `payload_locked_documents_rels_volunteers_id_idx` ON `payload_locked_documents_rels` (`volunteers_id`);
CREATE INDEX `payload_locked_documents_rels_locations_id_idx` ON `payload_locked_documents_rels` (`locations_id`);
CREATE INDEX `payload_locked_documents_rels_location_photos_id_idx` ON `payload_locked_documents_rels` (`location_photos_id`);
CREATE INDEX `payload_locked_documents_rels_guests_id_idx` ON `payload_locked_documents_rels` (`guests_id`);
CREATE INDEX `payload_locked_documents_rels_activities_id_idx` ON `payload_locked_documents_rels` (`activities_id`);
CREATE INDEX `payload_locked_documents_rels_activity_guests_id_idx` ON `payload_locked_documents_rels` (`activity_guests_id`);
CREATE INDEX `payload_locked_documents_rels_schedule_id_idx` ON `payload_locked_documents_rels` (`schedule_id`);
CREATE TABLE `payload_preferences` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`key` text,
  	`value` text,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE INDEX `payload_preferences_key_idx` ON `payload_preferences` (`key`);
CREATE INDEX `payload_preferences_updated_at_idx` ON `payload_preferences` (`updated_at`);
CREATE INDEX `payload_preferences_created_at_idx` ON `payload_preferences` (`created_at`);
CREATE TABLE `payload_preferences_rels` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`order` integer,
  	`parent_id` integer NOT NULL,
  	`path` text NOT NULL,
  	`users_id` integer,
  	FOREIGN KEY (`parent_id`) REFERENCES `payload_preferences`(`id`) ON UPDATE no action ON DELETE cascade,
  	FOREIGN KEY (`users_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
  );
CREATE INDEX `payload_preferences_rels_order_idx` ON `payload_preferences_rels` (`order`);
CREATE INDEX `payload_preferences_rels_parent_idx` ON `payload_preferences_rels` (`parent_id`);
CREATE INDEX `payload_preferences_rels_path_idx` ON `payload_preferences_rels` (`path`);
CREATE INDEX `payload_preferences_rels_users_id_idx` ON `payload_preferences_rels` (`users_id`);
CREATE TABLE `payload_migrations` (
  	`id` integer PRIMARY KEY NOT NULL,
  	`name` text,
  	`batch` numeric,
  	`updated_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL,
  	`created_at` text DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')) NOT NULL
  );
CREATE INDEX `payload_migrations_updated_at_idx` ON `payload_migrations` (`updated_at`);
CREATE INDEX `payload_migrations_created_at_idx` ON `payload_migrations` (`created_at`);
