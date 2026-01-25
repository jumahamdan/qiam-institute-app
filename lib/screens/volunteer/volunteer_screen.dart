import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  final List<String> _volunteerAreas = [
    'Event Organization',
    'Teaching/Education',
    'Youth Programs',
    'Administrative Support',
    'Social Media/Marketing',
    'Facilities/Maintenance',
    'Community Outreach',
    'Other',
  ];

  final Set<String> _selectedAreas = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one volunteer area')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Build email body
    final subject = 'Volunteer Application - ${_nameController.text}';
    final body = '''
Volunteer Application

Name: ${_nameController.text}
Email: ${_emailController.text}
Phone: ${_phoneController.text}

Areas of Interest:
${_selectedAreas.map((a) => '• $a').join('\n')}

Additional Message:
${_messageController.text.isEmpty ? 'N/A' : _messageController.text}

---
Sent from Qiam Institute App
''';

    final emailUri = Uri(
      scheme: 'mailto',
      path: AppConstants.contactEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening email app...'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open email. Please email ${AppConstants.contactEmail} directly.'),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.volunteer_activism,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Join Our Team',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help us serve the community by volunteering your time and skills',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Volunteer Areas
              Text(
                'Areas of Interest *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _volunteerAreas.map((area) {
                  final isSelected = _selectedAreas.contains(area);
                  return FilterChip(
                    label: Text(area),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAreas.add(area);
                        } else {
                          _selectedAreas.remove(area);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Message Field
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Additional Message (Optional)',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.message),
                  ),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Application'),
              ),
              const SizedBox(height: 16),

              // Contact Info
              Text(
                'Or contact us directly at:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.contactEmail,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
