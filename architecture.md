# VoiceEd - Inclusive Exams Architecture

## Overview
VoiceEd is a fully voice-driven exam platform for visually impaired students with Speech-to-Text (STT) and Text-to-Speech (TTS) capabilities.

## Core Features
1. **Voice-First Interaction**: Primary navigation and control through voice commands
2. **Full TTS Integration**: All content read aloud automatically
3. **STT for Answers**: Voice input for exam responses
4. **Accessibility**: WCAG 2.1 AA compliance with keyboard navigation fallback
5. **Role-Based Access**: Student and Admin roles

## Pages Structure
1. **Landing Page**: Introduction, features showcase, "Start with Voice" CTA
2. **Login/Register**: Role selection (Student/Admin) with voice hints
3. **Dashboard**: Voice-navigable overview of exams and statistics
4. **Exam Page**: Core voice-driven exam interface with commands
5. **Results Page**: Auto-read results with TTS feedback
6. **Admin Panel**: Create/manage exams and monitor students

## Voice Commands (Exam Page)
- "Next question" / "Previous question"
- "Repeat question"
- "Option A/B/C/D"
- "Submit answer"
- "End exam"
- "Help" (list available commands)

## Data Models
1. **User**: id, name, email, password, role (student/admin), created_at, updated_at
2. **Exam**: id, title, description, duration_minutes, questions, created_by, created_at, updated_at
3. **Question**: id, text, options, correct_answer, exam_id
4. **ExamAttempt**: id, user_id, exam_id, answers, score, started_at, completed_at, created_at

## Services (Local Storage)
1. **AuthService**: Handle login, register, logout, session management
2. **ExamService**: CRUD operations for exams with sample data
3. **QuestionService**: Manage questions for exams
4. **ExamAttemptService**: Track student attempts and scores
5. **VoiceService**: TTS and STT wrapper service
6. **LocalStorageService**: Persistent data storage

## Technology Stack
- **Frontend**: Flutter Web (responsive design)
- **Voice**: flutter_tts (TTS) + speech_to_text (STT)
- **Storage**: shared_preferences for local persistence
- **State Management**: StatefulWidget + InheritedWidget for auth state

## Design System
- **Colors**: Blue/Purple gradient theme with high contrast
- **Typography**: Poppins font family for elegance (large, readable sizes)
- **Spacing**: Generous padding (24-32px), large touch targets (60x60)
- **Layout**: Bottom navigation, rounded corners (16px), floating action buttons
- **Accessibility**: 4.5:1 contrast ratio minimum, visible focus states

## Implementation Steps
1. Add dependencies: flutter_tts, speech_to_text, shared_preferences
2. Update theme with modern blue/purple palette and Poppins font
3. Create data models with JSON serialization
4. Implement service layer with local storage
5. Build authentication flow (login/register screens)
6. Create landing page with voice introduction
7. Build dashboard with voice navigation
8. Implement core exam page with full voice control
9. Create results page with TTS readout
10. Build admin panel for exam management
11. Add voice command hints overlay on all pages
12. Test accessibility and keyboard navigation
13. Compile and fix any errors
