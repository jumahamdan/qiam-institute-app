import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Availability Controllers
  final _hoursAvailableController = TextEditingController();
  final _timesAvailableController = TextEditingController();
  final _weeklyHoursController = TextEditingController();
  final _skillsController = TextEditingController();

  String? _selectedState;

  // Address autocomplete
  List<Map<String, String>> _addressSuggestions = [];
  bool _isLoadingAddresses = false;
  Timer? _addressDebounce;
  final LayerLink _addressLayerLink = LayerLink();
  OverlayEntry? _addressOverlay;

  final List<String> _usStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
    'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
    'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
    'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
    'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
    'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
    'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
    'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
    'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
    'West Virginia', 'Wisconsin', 'Wyoming'
  ];

  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  final Set<String> _selectedDays = {};

  final List<String> _interestAreas = [
    'Education',
    'Events',
    'Youth Programs',
    'Women\'s Programs',
    'Community Outreach',
    'Social Media/Marketing',
    'Administrative Support',
    'Facilities/Maintenance',
    'Food Services',
    'Transportation',
    'Fundraising',
    'Counseling/Support',
    'Other',
  ];
  final Set<String> _selectedAreas = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedState = 'Illinois'; // Default to Illinois
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _hoursAvailableController.dispose();
    _timesAvailableController.dispose();
    _weeklyHoursController.dispose();
    _skillsController.dispose();
    _addressDebounce?.cancel();
    _hideAddressOverlay();
    super.dispose();
  }

  void _onAddressChanged(String query) {
    _addressDebounce?.cancel();

    if (query.length < 3) {
      _hideAddressOverlay();
      setState(() {
        _addressSuggestions = [];
        _isLoadingAddresses = false;
      });
      return;
    }

    setState(() => _isLoadingAddresses = true);

    _addressDebounce = Timer(const Duration(milliseconds: 500), () {
      _fetchAddressSuggestions(query);
    });
  }

  Future<void> _fetchAddressSuggestions(String query) async {
    try {
      // Use OpenStreetMap Nominatim API (free, no API key needed)
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&addressdetails=1'
        '&limit=5'
        '&countrycodes=us',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'QiamInstituteApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _addressSuggestions = data.map((item) {
            final address = item['address'] as Map<String, dynamic>?;
            return {
              'description': item['display_name'] as String? ?? '',
              'house_number': address?['house_number'] as String? ?? '',
              'road': (address?['road'] ?? address?['street'] ?? '') as String,
              'city': (address?['city'] ?? address?['town'] ?? address?['village'] ?? address?['municipality'] ?? '') as String,
              'state': address?['state'] as String? ?? '',
              'postcode': address?['postcode'] as String? ?? '',
            };
          }).toList();
          _isLoadingAddresses = false;
        });

        if (_addressSuggestions.isNotEmpty) {
          _showAddressOverlay();
        }
      } else {
        setState(() {
          _addressSuggestions = [];
          _isLoadingAddresses = false;
        });
      }
    } catch (e) {
      setState(() {
        _addressSuggestions = [];
        _isLoadingAddresses = false;
      });
    }
  }

  void _selectAddress(Map<String, String> suggestion) {
    _hideAddressOverlay();

    // Extract address components from Nominatim response
    final houseNumber = suggestion['house_number'] ?? '';
    final road = suggestion['road'] ?? '';
    final city = suggestion['city'] ?? '';
    final state = suggestion['state'] ?? '';
    final postcode = suggestion['postcode'] ?? '';

    setState(() {
      // Build street address
      if (houseNumber.isNotEmpty && road.isNotEmpty) {
        _addressController.text = '$houseNumber $road';
      } else if (road.isNotEmpty) {
        _addressController.text = road;
      } else {
        // Fallback to first part of description
        final description = suggestion['description'] ?? '';
        final parts = description.split(',');
        _addressController.text = parts.isNotEmpty ? parts[0].trim() : description;
      }

      // Auto-populate city
      if (city.isNotEmpty) {
        _cityController.text = city;
      }

      // Auto-populate zip code
      if (postcode.isNotEmpty) {
        _zipController.text = postcode;
      }

      // Find and select matching state in dropdown
      if (state.isNotEmpty) {
        final matchingState = _usStates.firstWhere(
          (s) => s.toLowerCase() == state.toLowerCase(),
          orElse: () => _selectedState ?? 'Illinois',
        );
        _selectedState = matchingState;
      }

      _addressSuggestions = [];
    });
  }

  void _showAddressOverlay() {
    _hideAddressOverlay();

    _addressOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _addressLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _addressSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _addressSuggestions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                    title: Text(
                      suggestion['description'] ?? '',
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _selectAddress(suggestion),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_addressOverlay!);
  }

  void _hideAddressOverlay() {
    _addressOverlay?.remove();
    _addressOverlay = null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your date of birth';
    }
    // Check format MM/DD/YYYY
    final regex = RegExp(r'^(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])/\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid date (MM/DD/YYYY)';
    }
    // Parse and validate the date
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final day = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    if (year < 1940 || year > DateTime.now().year) {
      return 'Please enter a valid year';
    }

    // Check if date is valid
    try {
      final date = DateTime(year, month, day);
      if (date.month != month || date.day != day) {
        return 'Invalid date';
      }
      if (date.isAfter(DateTime.now())) {
        return 'Date cannot be in the future';
      }
    } catch (_) {
      return 'Invalid date';
    }

    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one area of interest')),
      );
      return;
    }
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day of availability')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Build form data
    final formData = {
      '_subject': 'Volunteer Application - ${_nameController.text}',
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'date_of_birth': _dobController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'state': _selectedState ?? '',
      'zip_code': _zipController.text,
      'hours_available': _hoursAvailableController.text,
      'days_available': _selectedDays.join(', '),
      'times_available': _timesAvailableController.text,
      'weekly_hours': _weeklyHoursController.text,
      'skills_experience': _skillsController.text.isEmpty ? 'N/A' : _skillsController.text,
      'areas_of_interest': _selectedAreas.join(', '),
      '_template': 'table',
    };

    try {
      final response = await http.post(
        Uri.parse(AppConstants.formspreeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (mounted) {
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
          // Success - clear form and show success message
          _clearForm();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application submitted successfully! We will contact you soon.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit. Please try again or email ${AppConstants.contactEmail}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error. Please check your connection or email ${AppConstants.contactEmail}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _dobController.clear();
    _addressController.clear();
    _cityController.clear();
    _zipController.clear();
    _phoneController.clear();
    _emailController.clear();
    _hoursAvailableController.clear();
    _timesAvailableController.clear();
    _weeklyHoursController.clear();
    _skillsController.clear();
    setState(() {
      _selectedDays.clear();
      _selectedAreas.clear();
      _selectedState = 'Illinois';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return just the body - MainNavigation provides the Scaffold and AppBar
    return SingleChildScrollView(
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

              // Section: Personal Information
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 16),

              // Full Name
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

              // Date of Birth
              TextFormField(
                controller: _dobController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  _DateInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Date of Birth *',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  hintText: 'MM/DD/YYYY',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _selectDate,
                    tooltip: 'Pick from calendar',
                  ),
                ),
                validator: _validateDate,
              ),
              const SizedBox(height: 16),

              // Address with autocomplete
              CompositedTransformTarget(
                link: _addressLayerLink,
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address *',
                    prefixIcon: const Icon(Icons.home),
                    border: const OutlineInputBorder(),
                    hintText: 'Start typing to search...',
                    suffixIcon: _isLoadingAddresses
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                  onChanged: _onAddressChanged,
                  onTap: () {
                    if (_addressSuggestions.isNotEmpty) {
                      _showAddressOverlay();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // City and State Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedState,
                      decoration: const InputDecoration(
                        labelText: 'State *',
                        border: OutlineInputBorder(),
                      ),
                      items: _usStates.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedState = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Zip Code
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Zip Code *',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your zip code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
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
              const SizedBox(height: 16),

              // Email
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
              const SizedBox(height: 32),

              // Section: Availability
              _buildSectionHeader('Availability'),
              const SizedBox(height: 16),

              // Hours Available
              TextFormField(
                controller: _hoursAvailableController,
                decoration: const InputDecoration(
                  labelText: 'Hours Available (e.g., 9 AM - 5 PM)',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Days Available
              Text(
                'Days Available *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _daysOfWeek.map((day) {
                  final isSelected = _selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day.substring(0, 3)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Times Available
              TextFormField(
                controller: _timesAvailableController,
                decoration: const InputDecoration(
                  labelText: 'Times Available (e.g., Mornings, Evenings)',
                  prefixIcon: Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Weekly Hours
              TextFormField(
                controller: _weeklyHoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hours per Week You Can Volunteer',
                  prefixIcon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // Section: Skills & Interests
              _buildSectionHeader('Skills & Interests'),
              const SizedBox(height: 16),

              // Skills/Experience
              TextFormField(
                controller: _skillsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Skills & Experience',
                  hintText: 'Tell us about your relevant skills, experience, or qualifications...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // Interest Areas
              Text(
                'Areas of Interest *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _interestAreas.map((area) {
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
              const SizedBox(height: 32),

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
              const SizedBox(height: 24),
            ],
          ),
        ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

/// Custom TextInputFormatter for MM/DD/YYYY date format
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extract only digits from the new value
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final oldDigitsOnly = oldValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 8 digits (MMDDYYYY)
    String digits = digitsOnly;
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    // Format as MM/DD/YYYY
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    // Calculate cursor position
    int cursorPosition = formatted.length;

    // If user is deleting, try to maintain relative cursor position
    if (digitsOnly.length < oldDigitsOnly.length) {
      // Find where the cursor should be after deletion
      final oldCursor = oldValue.selection.baseOffset;
      int digitsBefore = 0;
      for (int i = 0; i < oldCursor && i < oldValue.text.length; i++) {
        if (RegExp(r'\d').hasMatch(oldValue.text[i])) {
          digitsBefore++;
        }
      }
      // Map digits position to formatted position
      int newCursor = 0;
      int digitsCount = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (digitsCount >= digitsBefore - 1) {
          newCursor = i + 1;
          break;
        }
        if (RegExp(r'\d').hasMatch(formatted[i])) {
          digitsCount++;
        }
        newCursor = i + 1;
      }
      cursorPosition = newCursor.clamp(0, formatted.length);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
