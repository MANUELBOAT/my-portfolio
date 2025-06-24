-- Create the database
CREATE DATABASE church_management_system;
USE church_management_system;

-- Users table for authentication
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'pastor', 'deacon', 'elder', 'staff') NOT NULL,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Family/Household table
CREATE TABLE families (
    family_id INT AUTO_INCREMENT PRIMARY KEY,
    family_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    home_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- People table (members, pastors, volunteers, visitors)
CREATE TABLE people (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    family_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    email VARCHAR(100),
    phone VARCHAR(20),
    mobile VARCHAR(20),
    person_type ENUM('Member', 'Pastor', 'Deacon', 'Elder', 'Volunteer', 'Visitor') NOT NULL,
    membership_date DATE,
    is_baptized BOOLEAN DEFAULT FALSE,
    baptism_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (family_id) REFERENCES families(family_id)
);

-- Spiritual roles (pastors, deacons, elders)
CREATE TABLE spiritual_roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NOT NULL,
    role_type ENUM('Pastor', 'Deacon', 'Elder') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

-- Groups (Sunday school, fellowships, choirs)
CREATE TABLE `groups` (
    `group_id` INT AUTO_INCREMENT PRIMARY KEY,
    `group_name` VARCHAR(100) NOT NULL,
    `group_type` ENUM('Sunday School', 'Fellowship', 'Choir', 'Leaders Meeting', 'Other') NOT NULL,
    `description` TEXT,
    `meeting_day` ENUM('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') NULL,
    `meeting_time` TIME NULL,
    `meeting_frequency` ENUM('Weekly', 'Bi-weekly', 'Monthly', 'Quarterly', 'As Needed') NULL,
    `meeting_location` VARCHAR(100),
    `leader_id` INT NULL,
    `start_date` DATE NULL,
    `end_date` DATE NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`leader_id`) REFERENCES `people`(`person_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Group memberships
CREATE TABLE `group_memberships` (
    `membership_id` INT AUTO_INCREMENT PRIMARY KEY,
    `group_id` INT NOT NULL,
    `person_id` INT NOT NULL,
    `role` VARCHAR(50),
    `role_description` TEXT NULL,
    `join_date` DATE NOT NULL DEFAULT (CURRENT_DATE),
    `leave_date` DATE NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`group_id`) REFERENCES `groups`(`group_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (`person_id`) REFERENCES `people`(`person_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE KEY `unique_membership` (`group_id`, `person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ministries (Outreach, youth, missions)
CREATE TABLE ministries (
    ministry_id INT AUTO_INCREMENT PRIMARY KEY,
    ministry_name VARCHAR(100) NOT NULL,
    description TEXT,
    leader_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (leader_id) REFERENCES people(person_id)
);

-- Ministry participation
CREATE TABLE ministry_participation (
    participation_id INT AUTO_INCREMENT PRIMARY KEY,
    ministry_id INT NOT NULL,
    person_id INT NOT NULL,
    role VARCHAR(50),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ministry_id) REFERENCES ministries(ministry_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

-- Events (services, meetings, special events)
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_type ENUM('Service', 'Meeting', 'Special Event', 'Communion', 'Baptism') NOT NULL,
    description TEXT,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME,
    location VARCHAR(100),
    expected_count INT,
    actual_count INT,
    notes TEXT
);

-- Event participants
CREATE TABLE event_participants (
    participation_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    person_id INT,
    role VARCHAR(50),
    attended BOOLEAN DEFAULT FALSE,
    notes TEXT,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

-- Sacraments (communion, baptism)
CREATE TABLE sacraments (
    sacrament_id INT AUTO_INCREMENT PRIMARY KEY,
    sacrament_type ENUM('Communion', 'Baptism') NOT NULL,
    event_id INT,
    person_id INT NOT NULL,
    sacrament_date DATE NOT NULL,
    administered_by INT,
    notes TEXT,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (administered_by) REFERENCES people(person_id)
);

-- Financial records (tithes, offerings)
CREATE TABLE financial_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT,
    family_id INT,
    transaction_type ENUM('Tithe', 'Offering', 'Donation', 'Other') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Cash', 'Check', 'Credit Card', 'Online', 'Other') NOT NULL,
    transaction_date DATE NOT NULL,
    fund VARCHAR(50),
    check_number VARCHAR(20),
    notes TEXT,
    recorded_by INT NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (family_id) REFERENCES families(family_id),
    FOREIGN KEY (recorded_by) REFERENCES users(user_id)
);

-- Budget
CREATE TABLE budget (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    fiscal_year YEAR NOT NULL,
    category VARCHAR(100) NOT NULL,
    budget_amount DECIMAL(10,2) NOT NULL,
    actual_amount DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT
);

-- Documents storage
CREATE TABLE documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    document_type ENUM('Sermon', 'Bulletin', 'Report', 'Form', 'Other') NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_by INT NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- Reports
CREATE TABLE saved_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    parameters TEXT,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_run_at TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Create admin user (execute this after tables are created)
INSERT INTO users (username, password_hash, email, role)
VALUES ('admin', '$2y$10$YourHashedPasswordHere', 'admin@yourchurch.org', 'admin');

-- Create permissions system
CREATE TABLE permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE role_permissions (
    role_permission_id INT AUTO_INCREMENT PRIMARY KEY,
    role VARCHAR(50) NOT NULL,
    permission_id INT NOT NULL,
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
);

-- Sample permissions (expand as needed)
INSERT INTO permissions (permission_name, description) VALUES
('view_members', 'View member information'),
('edit_members', 'Edit member information'),
('view_financial', 'View financial records'),
('edit_financial', 'Edit financial records'),
('manage_users', 'Create/edit users and permissions'),
('upload_documents', 'Upload documents to the system');