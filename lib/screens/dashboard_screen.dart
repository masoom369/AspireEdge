import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String role; // 'admin', 'student', 'postgraduate', 'professional'

  const DashboardPage({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://via.placeholder.com/100/667EEA/FFFFFF?text=U'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeBanner(context),

              const SizedBox(height: 20),

              // Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: _getStats().map((stat) => _buildStatCard(
                  stat['title'] as String,
                  stat['value'] as String,
                  stat['subtitle'] as String,
                  stat['icon'] as IconData,
                  stat['color'] as Color,
                )).toList(),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(context),

              const SizedBox(height: 20),

              // Recommended Courses/Paths
              _buildRecommendedSection(context),

              const SizedBox(height: 20),

              // Profile Completion (for students only)
              if (role != 'admin') ...[
                _buildProfileCompletion(context),
                const SizedBox(height: 20),
              ],

              // Success Story & Events (Admin gets Reports & User Mgmt)
              _buildBottomSection(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (role) {
      case 'admin': return 'Admin Dashboard';
      case 'student': return 'Student Hub';
      case 'postgraduate': return 'Postgrad Pathways';
      case 'professional': return 'Career Accelerator';
      default: return 'Dashboard';
    }
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    final data = _getWelcomeData();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data['gradient'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (data['gradient'] as List<Color>)[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data['subtitle'] as String,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          if ((data['actions'] as List).isNotEmpty) ...[
            Row(
              children: (data['actions'] as List<Map<String, dynamic>>).map((action) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: action['primary'] ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: !action['primary']
                          ? Border.all(color: Colors.white.withOpacity(0.3))
                          : null,
                    ),
                    child: Text(
                      action['label'] as String,
                      style: TextStyle(
                        color: action['primary'] ? Colors.white : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, dynamic> _getWelcomeData() {
    switch (role) {
      case 'admin':
        return {
          'title': 'Welcome back, Admin!',
          'subtitle': 'Manage users, content, and system analytics.',
          'gradient': [const Color(0xFF764BA2), const Color(0xFF667EEA)],
          'actions': [
            {'label': 'View Reports', 'primary': true},
            {'label': 'Manage Users', 'primary': false},
          ],
        };
      case 'student':
        return {
          'title': 'Welcome back, Alex Student!',
          'subtitle': 'Continue your learning journey and explore new career opportunities.',
          'gradient': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          'actions': [
            {'label': 'Take Career Quiz', 'primary': true},
            {'label': 'Browse Careers', 'primary': false},
          ],
        };
      case 'postgraduate':
        return {
          'title': 'Welcome back, Research Scholar!',
          'subtitle': 'Advance your expertise and connect with industry leaders.',
          'gradient': [const Color(0xFF9C27B0), const Color(0xFF673AB7)],
          'actions': [
            {'label': 'Find Research Grants', 'primary': true},
            {'label': 'Join Conferences', 'primary': false},
          ],
        };
      case 'professional':
        return {
          'title': 'Welcome back, Career Professional!',
          'subtitle': 'Upskill, network, and unlock new career heights.',
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFF5722)],
          'actions': [
            {'label': 'Update Resume', 'primary': true},
            {'label': 'Explore Jobs', 'primary': false},
          ],
        };
      default:
        return {
          'title': 'Welcome!',
          'subtitle': 'Your personalized dashboard.',
          'gradient': [Colors.blue, Colors.purple],
          'actions': [],
        };
    }
  }

  List<Map<String, dynamic>> _getStats() {
    switch (role) {
      case 'admin':
        return [
          {'title': 'Total Users', 'value': '12,450', 'subtitle': '+240 this week', 'icon': Icons.people, 'color': const Color(0xFF667EEA)},
          {'title': 'Active Courses', 'value': '89', 'subtitle': '5 new this month', 'icon': Icons.school, 'color': const Color(0xFF4CAF50)},
          {'title': 'Revenue', 'value': '\$24K', 'subtitle': '+\$1.2K today', 'icon': Icons.attach_money, 'color': const Color(0xFFFF9800)},
          {'title': 'Support Tickets', 'value': '12', 'subtitle': '4 unresolved', 'icon': Icons.headset_mic, 'color': const Color(0xFF9C27B0)},
        ];
      case 'student':
        return [
          {'title': 'Courses Completed', 'value': '3', 'subtitle': '1 this week', 'icon': Icons.school, 'color': const Color(0xFF667EEA)},
          {'title': 'Quiz Score', 'value': '85%', 'subtitle': 'Average score', 'icon': Icons.quiz, 'color': const Color(0xFF4CAF50)},
          {'title': 'Career Matches', 'value': '12', 'subtitle': '3 new matches', 'icon': Icons.work, 'color': const Color(0xFFFF9800)},
          {'title': 'Learning Hours', 'value': '24h', 'subtitle': '5h this month', 'icon': Icons.timer, 'color': const Color(0xFF9C27B0)},
        ];
      case 'postgraduate':
        return [
          {'title': 'Research Papers', 'value': '5', 'subtitle': '2 under review', 'icon': Icons.description, 'color': const Color(0xFF667EEA)},
          {'title': 'Grants Applied', 'value': '3', 'subtitle': '1 awarded', 'icon': Icons.monetization_on, 'color': const Color(0xFF4CAF50)},
          {'title': 'Conferences', 'value': '2', 'subtitle': 'Next in 14 days', 'icon': Icons.event, 'color': const Color(0xFFFF9800)},
          {'title': 'Mentors', 'value': '4', 'subtitle': '2 new connections', 'icon': Icons.group, 'color': const Color(0xFF9C27B0)},
        ];
      case 'professional':
        return [
          {'title': 'Skills Mastered', 'value': '18', 'subtitle': '+2 this month', 'icon': Icons.star, 'color': const Color(0xFF667EEA)},
          {'title': 'Job Applications', 'value': '7', 'subtitle': '2 interviews', 'icon': Icons.work, 'color': const Color(0xFF4CAF50)},
          {'title': 'Network Size', 'value': '245', 'subtitle': '+12 this week', 'icon': Icons.groups, 'color': const Color(0xFFFF9800)},
          {'title': 'Certifications', 'value': '5', 'subtitle': 'AWS Certified', 'icon': Icons.verified, 'color': const Color(0xFF9C27B0)},
        ];
      default:
        return [];
    }
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = _getQuickActions();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getQuickActionsSubtitle(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...actions.map((action) => _buildActionItem(
            action['title'] as String,
            action['subtitle'] as String,
            action['icon'] as IconData,
            action['color'] as Color,
          )).toList(),
        ],
      ),
    );
  }

  String _getQuickActionsSubtitle() {
    switch (role) {
      case 'admin': return 'Manage platform efficiently';
      case 'student': return 'Take action to advance your career';
      case 'postgraduate': return 'Boost your academic profile';
      case 'professional': return 'Grow your professional brand';
      default: return 'Recommended next steps';
    }
  }

  List<Map<String, dynamic>> _getQuickActions() {
    switch (role) {
      case 'admin':
        return [
          {'title': 'Review New Users', 'subtitle': 'Approve or reject registrations', 'icon': Icons.person_add, 'color': const Color(0xFF667EEA)},
          {'title': 'Content Moderation', 'subtitle': 'Review reported materials', 'icon': Icons.flag, 'color': const Color(0xFFFF9800)},
          {'title': 'Send Announcement', 'subtitle': 'Notify all users', 'icon': Icons.notifications, 'color': const Color(0xFF4CAF50)},
        ];
      case 'student':
        return [
          {'title': 'Complete Profile', 'subtitle': 'Add more details to get better recommendations', 'icon': Icons.person, 'color': const Color(0xFF4CAF50)},
          {'title': 'Take Assessment', 'subtitle': 'Discover your career strengths', 'icon': Icons.assessment, 'color': const Color(0xFF667EEA)},
          {'title': 'Join Study Group', 'subtitle': 'Connect with fellow students', 'icon': Icons.group, 'color': const Color(0xFF9C27B0)},
        ];
      case 'postgraduate':
        return [
          {'title': 'Submit Paper', 'subtitle': 'Upload to institutional repository', 'icon': Icons.upload, 'color': const Color(0xFF667EEA)},
          {'title': 'Apply for Grant', 'subtitle': 'Deadline in 7 days', 'icon': Icons.attach_money, 'color': const Color(0xFF4CAF50)},
          {'title': 'Schedule Advisor Mtg', 'subtitle': 'Discuss thesis progress', 'icon': Icons.calendar_today, 'color': const Color(0xFFFF9800)},
        ];
      case 'professional':
        return [
          {'title': 'Update LinkedIn', 'subtitle': 'Sync your latest achievements', 'icon': Icons.link, 'color': const Color(0xFF667EEA)},
          {'title': 'Practice Interview', 'subtitle': 'AI-simulated mock session', 'icon': Icons.videocam, 'color': const Color(0xFF4CAF50)},
          {'title': 'Request Referral', 'subtitle': 'Ask connections for opportunities', 'icon': Icons.person_pin, 'color': const Color(0xFFFF9800)},
        ];
      default:
        return [];
    }
  }

  Widget _buildRecommendedSection(BuildContext context) {
    final items = _getRecommendedItems();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.recommend, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                _getRecommendedTitle(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getRecommendedSubtitle(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                _buildCourseCard(
                  item['title'] as String,
                  item['description'] as String,
                  item['level'] as String,
                  item['duration'] as String,
                  item['color'] as Color,
                  item['emoji'] as String,
                ),
                if (index < items.length - 1) const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _getRecommendedTitle() {
    switch (role) {
      case 'admin': return 'System Alerts';
      case 'student': return 'Recommended for You';
      case 'postgraduate': return 'Research Opportunities';
      case 'professional': return 'Career Growth Paths';
      default: return 'Recommended';
    }
  }

  String _getRecommendedSubtitle() {
    switch (role) {
      case 'admin': return 'Critical system updates and suggestions';
      case 'student': return 'Career paths that match your profile';
      case 'postgraduate': return 'Funding, publishing, and collaboration';
      case 'professional': return 'Courses and certifications to advance';
      default: return 'Personalized recommendations';
    }
  }

  List<Map<String, dynamic>> _getRecommendedItems() {
    switch (role) {
      case 'admin':
        return [
          {
            'title': 'User Growth Spike',
            'description': '320 new signups this week — consider scaling servers.',
            'level': 'Alert',
            'duration': 'High Priority',
            'color': const Color(0xFFFF5722),
            'emoji': '📈',
          },
          {
            'title': 'Content Moderation Queue',
            'description': '14 reports awaiting review. Prioritize flagged quizzes.',
            'level': 'Action Needed',
            'duration': 'Medium Priority',
            'color': const Color(0xFFFF9800),
            'emoji': '⚠️',
          },
        ];
      case 'student':
        return [
          {
            'title': 'Software Engineering',
            'description': 'Become a skilled software developer with expertise in modern programming languages.',
            'level': 'Beginner',
            'duration': '6-12 months',
            'color': const Color(0xFFFF5722),
            'emoji': '🚀',
          },
          {
            'title': 'Digital Marketing',
            'description': 'Master the art of digital marketing and grow online presence.',
            'level': 'Beginner',
            'duration': '3-6 months',
            'color': const Color(0xFF2196F3),
            'emoji': '📱',
          },
          {
            'title': 'Data Science',
            'description': 'Analyze data to uncover insights and drive decisions.',
            'level': 'Intermediate',
            'duration': '8-12 months',
            'color': const Color(0xFF4CAF50),
            'emoji': '📊',
          },
        ];
      case 'postgraduate':
        return [
          {
            'title': 'NSF Research Grant',
            'description': 'Funding up to 50K for AI/ML research projects.',
            'level': 'Advanced',
            'duration': 'Apply by Apr 30',
            'color': const Color(0xFF4CAF50),
            'emoji': '💰',
          },
          {
            'title': 'IEEE Conference',
            'description': 'Present your work in San Francisco. Travel grants available.',
            'level': 'All Levels',
            'duration': 'June 10-14',
            'color': const Color(0xFF9C27B0),
            'emoji': '🎤',
          },
        ];
      case 'professional':
        return [
          {
            'title': 'AWS Solutions Architect',
            'description': 'Validate your cloud expertise and boost your market value.',
            'level': 'Professional',
            'duration': 'Exam Prep: 4-6 wks',
            'color': const Color(0xFFFF9800),
            'emoji': '☁️',
          },
          {
            'title': 'Leadership & Management',
            'description': 'Transition from contributor to people leader.',
            'level': 'Intermediate',
            'duration': '8 weeks',
            'color': const Color(0xFF667EEA),
            'emoji': '👔',
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildProfileCompletion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              const Text(
                'Profile Completion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _getProfileProgress(),
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(_getProfileProgress() * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._getChecklistItems().map((item) => _buildChecklistItem(
            item['text'] as String,
            item['completed'] as bool,
          )).toList(),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Complete Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getProfileProgress() {
    switch (role) {
      case 'student': return 0.75;
      case 'postgraduate': return 0.85;
      case 'professional': return 0.9;
      default: return 0.5;
    }
  }

  List<Map<String, dynamic>> _getChecklistItems() {
    switch (role) {
      case 'student':
        return [
          {'text': 'Basic info completed', 'completed': true},
          {'text': 'Skills added', 'completed': true},
          {'text': 'Add experience', 'completed': false},
          {'text': 'Upload resume', 'completed': false},
        ];
      case 'postgraduate':
        return [
          {'text': 'Thesis title added', 'completed': true},
          {'text': 'Advisor assigned', 'completed': true},
          {'text': 'Research abstract', 'completed': true},
          {'text': 'Publications list', 'completed': false},
        ];
      case 'professional':
        return [
          {'text': 'Current role updated', 'completed': true},
          {'text': 'Skills endorsed', 'completed': true},
          {'text': 'Resume uploaded', 'completed': true},
          {'text': 'LinkedIn connected', 'completed': false},
        ];
      default:
        return [];
    }
  }

  Widget _buildBottomSection(BuildContext context) {
    if (role == 'admin') {
      return _buildAdminReports(context);
    } else {
      return _buildSuccessAndEvents(context);
    }
  }

  Widget _buildAdminReports(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Color(0xFFFF9800), size: 18),
              const SizedBox(width: 6),
              const Text(
                'System Reports',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildReportItem('Active Users', '1,240', '↑ 12% from last week'),
          _buildReportItem('Course Completions', '328', '↑ 8%'),
          _buildReportItem('Avg. Session Time', '8m 24s', '↑ 22s'),
          const SizedBox(height: 8),
          const Text(
            'View Full Analytics',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String value, String trend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            trend,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessAndEvents(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFF9800), size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      'Success Story',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Jessica Martinez',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Software Engineer at TechCorp',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"AspireEdge transformed my career! The personalized guidance helped me transition from marketing to tech in just 8 months."',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Read More Stories',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.event, color: Color(0xFF4CAF50), size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildEventItem('Career Fair 2024', 'March 15th, 2PM'),
                _buildEventItem('Tech Industry Panel', 'March 20th, 4PM'),
                _buildEventItem('Resume Workshop', 'March 25th, 6PM'),
                const SizedBox(height: 8),
                const Text(
                  'View All Events',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Reusable Widgets (unchanged from original) ---

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              const Icon(Icons.more_vert, color: Colors.grey, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String title, String description, String level, String duration, Color color, String emoji) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: completed ? const Color(0xFF4CAF50) : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: completed ? Colors.black : Colors.grey,
              fontWeight: completed ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}