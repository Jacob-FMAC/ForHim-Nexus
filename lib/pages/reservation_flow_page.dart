import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/particle_background.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/futuristic_input.dart';
import '../config/theme_config.dart';
import '../l10n/app_strings.dart';
import '../config/constants.dart';
import 'ticket_page.dart';

class ReservationFlowPage extends StatefulWidget {
  const ReservationFlowPage({super.key});

  @override
  State<ReservationFlowPage> createState() => _ReservationFlowPageState();
}

class _ReservationFlowPageState extends State<ReservationFlowPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ReservationProvider>(context, listen: false);
      if (!provider.isSystemOpen && !provider.isReserved) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('closed', 'zh'))),
        );
      }
    });
  }
  
  String? _identityType;
  bool _forSelf = true;
  int _childCount = 1;
  String? _grade;
  String? _child1Grade;
  String? _child2Grade;

  final TextEditingController _cnNameController = TextEditingController();
  final TextEditingController _enNameController = TextEditingController();
  final TextEditingController _child1CnController = TextEditingController();
  final TextEditingController _child1EnController = TextEditingController();
  final TextEditingController _child2CnController = TextEditingController();
  final TextEditingController _child2EnController = TextEditingController();

  void _nextStep(int totalSteps) {
    if (_currentStep < totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    final provider = Provider.of<ReservationProvider>(context, listen: false);
    try {
      final payload = {
        'identity_type': _identityType,
        'chinese_name': _cnNameController.text,
        'english_name': _enNameController.text,
        'grade': _identityType == 'student' ? _grade : '',
        'for_self': _identityType == 'student' ? true : _forSelf,
        'child_count': _identityType == 'student' || _forSelf ? 0 : _childCount,
      };

      if (_identityType != 'student' && !_forSelf) {
        payload['child1_cn'] = _child1CnController.text;
        payload['child1_en'] = _child1EnController.text;
        payload['child1_grade'] = _child1Grade;
        if (_childCount > 1) {
          payload['child2_cn'] = _child2CnController.text;
          payload['child2_en'] = _child2EnController.text;
          payload['child2_grade'] = _child2Grade;
        }
      }

      final success = await provider.reserve(payload);
      if (success) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TicketPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocaleProvider>(context).locale.languageCode;
    final String fontFamily = ThemeConfig.getFontFamily(lang);

    List<Widget> steps = _buildSteps(lang, fontFamily);
    int totalSteps = steps.length;

    return Scaffold(
      backgroundColor: const Color(0xFF050A0E),
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                        onPressed: _prevStep,
                      ),
                      Expanded(
                        child: Text(
                          'STEP ${_currentStep + 1} / $totalSteps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 14,
                            letterSpacing: 2,
                            color: ThemeConfig.neonCyan,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / totalSteps,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation(ThemeConfig.neonCyan),
                      minHeight: 2,
                    ),
                  ),
                ),
                
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: steps,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSteps(String lang, String fontFamily) {
    List<Widget> steps = [];
    steps.add(_buildIdentityStep(lang, fontFamily, () => _nextStep(10))); // Use 10 as dummy until built, actual is computed

    if (_identityType == 'parent' || _identityType == 'staff') {
      steps.add(_buildTargetStep(lang, fontFamily, () => _nextStep(10)));
    }

    if (_identityType == 'student' || (_forSelf && _identityType != null)) {
      if (_identityType == 'student') {
        steps.add(_buildGradeStep(lang, fontFamily, () => _nextStep(10)));
      }
      steps.add(_buildNameStep(lang, fontFamily, () => _nextStep(10)));
    } else if (_identityType != null && !_forSelf) {
      steps.add(_buildChildCountStep(lang, fontFamily, () => _nextStep(10)));
      steps.add(_buildChildrenDetailsStep(lang, fontFamily, () => _nextStep(10)));
    }

    steps.add(_buildConfirmStep(lang, fontFamily, () => _nextStep(10)));

    // Re-bind the nextStep with actual total length to avoid issues, though our logic in nextStep uses passed totalSteps.
    return steps.map((w) {
      if (w is Builder) return w; // Just in case, normally they are padded widgets.
      return w;
    }).toList();
  }

  // Wrapper helper to inject actual steps length
  Widget _wrapStep(Widget step, int total) => step; 

  Widget _buildIdentityStep(String lang, String fontFamily, VoidCallback onNext) {
    final identities = [
      {'id': 'student', 'icon': Icons.school_rounded},
      {'id': 'parent', 'icon': Icons.family_restroom_rounded},
      {'id': 'staff', 'icon': Icons.badge_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('identity_title', lang),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: ThemeConfig.neonCyan,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...identities.map((id) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => _identityType = id['id'] as String);
                // Fix totalSteps issue by delaying the next to let UI rebuild first? 
                // Wait, if _identityType changes, totalSteps changes. 
                // Just calling next immediately is fine since nextStep uses _currentStep vs totalSteps in the current frame?
                // It's safer to wait a frame.
                Future.microtask(() {
                  final total = _buildSteps(lang, fontFamily).length;
                  _nextStep(total);
                });
              },
              child: GlassmorphismCard(
                borderColor: _identityType == id['id'] ? ThemeConfig.neonCyan : null,
                showGlow: _identityType == id['id'],
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(id['icon'] as IconData, size: 32, color: ThemeConfig.neonCyan),
                      const SizedBox(width: 20),
                      Text(
                        AppStrings.get(id['id'] as String, lang),
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white24),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTargetStep(String lang, String fontFamily, VoidCallback onNext) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('reserve_for_title', lang),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: ThemeConfig.neonCyan,
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              setState(() => _forSelf = true);
              Future.microtask(() => _nextStep(_buildSteps(lang, fontFamily).length));
            },
            child: GlassmorphismCard(
              borderColor: _forSelf ? ThemeConfig.neonCyan : null,
              showGlow: _forSelf,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 32, color: ThemeConfig.neonCyan),
                    const SizedBox(width: 20),
                    Text(
                      AppStrings.get('for_self', lang),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: fontFamily),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() => _forSelf = false);
              Future.microtask(() => _nextStep(_buildSteps(lang, fontFamily).length));
            },
            child: GlassmorphismCard(
              borderColor: !_forSelf ? ThemeConfig.neonCyan : null,
              showGlow: !_forSelf,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Icon(Icons.people, size: 32, color: ThemeConfig.neonCyan),
                    const SizedBox(width: 20),
                    Text(
                      AppStrings.get('for_students', lang),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: fontFamily),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChildCountStep(String lang, String fontFamily, VoidCallback onNext) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('student_count', lang),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: ThemeConfig.neonCyan,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [1, 2].map((count) => ChoiceChip(
              label: Text(count == 1 ? AppStrings.get('one_student', lang) : AppStrings.get('two_students', lang)),
              selected: _childCount == count,
              onSelected: (val) {
                setState(() => _childCount = count);
                Future.microtask(() => _nextStep(_buildSteps(lang, fontFamily).length));
              },
              selectedColor: ThemeConfig.neonCyan,
              backgroundColor: ThemeConfig.surfaceDark,
              labelStyle: TextStyle(
                color: _childCount == count ? ThemeConfig.backgroundDark : Colors.white70,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeStep(String lang, String fontFamily, VoidCallback onNext) {
    final grades = AppConstants.studentGrades;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('grade', lang),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: ThemeConfig.neonCyan,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: grades.map((g) => ChoiceChip(
              label: Text(g),
              selected: _grade == g,
              onSelected: (val) {
                setState(() => _grade = g);
                Future.microtask(() => _nextStep(_buildSteps(lang, fontFamily).length));
              },
              selectedColor: ThemeConfig.neonCyan,
              backgroundColor: ThemeConfig.surfaceDark,
              labelStyle: TextStyle(
                color: _grade == g ? ThemeConfig.backgroundDark : Colors.white70,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep(String lang, String fontFamily, VoidCallback onNext) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FuturisticInput(
            label: AppStrings.get('chinese_name', lang),
            hint: '例如：张三',
            controller: _cnNameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Chinese name is required';
              if (!RegExp(r'^[\u4e00-\u9fa5]+$').hasMatch(value)) {
                return 'Only Chinese characters allowed';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 30),
          FuturisticInput(
            label: AppStrings.get('english_name', lang),
            hint: 'Example: John Doe',
            controller: _enNameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'English name is required';
              if (!RegExp(r'^[A-Za-z\.]+$').hasMatch(value)) {
                return 'Only English letters and dots allowed';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 60),
          NeonButton(
            text: AppStrings.get('next', lang),
            onPressed: () {
              bool isCnValid = _cnNameController.text.isNotEmpty && RegExp(r'^[\u4e00-\u9fa5]+$').hasMatch(_cnNameController.text);
              bool isEnValid = _enNameController.text.isNotEmpty && RegExp(r'^[A-Za-z\.]+$').hasMatch(_enNameController.text);
              if (isCnValid && isEnValid) {
                Future.microtask(() => _nextStep(_buildSteps(lang, fontFamily).length));
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildChildrenDetailsStep(String lang, String fontFamily, VoidCallback onNext) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            AppStrings.get('child1_name', lang),
            style: TextStyle(color: ThemeConfig.neonCyan, fontFamily: fontFamily, fontSize: 20),
          ),
          const SizedBox(height: 16),
          FuturisticInput(
            label: AppStrings.get('chinese_name', lang),
            hint: '例如：张三',
            controller: _child1CnController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          FuturisticInput(
            label: AppStrings.get('english_name', lang),
            hint: 'Example: John Doe',
            controller: _child1EnController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          _buildDropdownGrade(lang, fontFamily, _child1Grade, (v) => setState(() => _child1Grade = v)),
          
          if (_childCount > 1) ...[
            const SizedBox(height: 40),
            Text(
              AppStrings.get('child2_name', lang),
              style: TextStyle(color: ThemeConfig.neonCyan, fontFamily: fontFamily, fontSize: 20),
            ),
            const SizedBox(height: 16),
            FuturisticInput(
              label: AppStrings.get('chinese_name', lang),
              hint: '例如：李四',
              controller: _child2CnController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            FuturisticInput(
              label: AppStrings.get('english_name', lang),
              hint: 'Example: Jane Doe',
              controller: _child2EnController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _buildDropdownGrade(lang, fontFamily, _child2Grade, (v) => setState(() => _child2Grade = v)),
          ],
          
          const SizedBox(height: 40),
          // We also need Parent's name for contact info! Wait, the requirements didn't explicitly say.
          // But reservation table requires chinese_name and english_name. We should collect the parent's name too.
          Text(
            AppStrings.get('identity_title', lang) + " (Contact Info)",
            style: TextStyle(color: ThemeConfig.neonCyan, fontFamily: fontFamily, fontSize: 16),
          ),
          const SizedBox(height: 16),
          FuturisticInput(
            label: AppStrings.get('chinese_name', lang),
            hint: 'Contact CN',
            controller: _cnNameController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          FuturisticInput(
            label: AppStrings.get('english_name', lang),
            hint: 'Contact EN',
            controller: _enNameController,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 40),
          NeonButton(
            text: AppStrings.get('next', lang),
            onPressed: () {
              bool valid = true;
              if (_child1CnController.text.isEmpty || _child1EnController.text.isEmpty || _child1Grade == null) valid = false;
              if (_childCount > 1 && (_child2CnController.text.isEmpty || _child2EnController.text.isEmpty || _child2Grade == null)) valid = false;
              if (_cnNameController.text.isEmpty || _enNameController.text.isEmpty) valid = false;
              if (valid) {
                 Future.microtask(() => _nextStep(_buildSteps(lang, fontFamily).length));
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownGrade(String lang, String fontFamily, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: AppConstants.studentGrades.map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(color: Colors.white)))).toList(),
      onChanged: onChanged,
      dropdownColor: ThemeConfig.surfaceDark,
      decoration: InputDecoration(
        labelText: AppStrings.get('grade', lang),
        labelStyle: TextStyle(color: ThemeConfig.neonCyan, fontFamily: fontFamily),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ThemeConfig.neonCyan.withOpacity(0.3))),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ThemeConfig.neonCyan)),
      ),
    );
  }

  Widget _buildConfirmStep(String lang, String fontFamily, VoidCallback onNext) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('confirm', lang),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: ThemeConfig.neonCyan,
            ),
          ),
          const SizedBox(height: 40),
          GlassmorphismCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildConfirmRow(AppStrings.get('identity_title', lang), AppStrings.get(_identityType ?? '', lang), fontFamily),
                    const Divider(color: Colors.white10, height: 32),
                    
                    if (_identityType == 'student' || _forSelf) ...[
                      if (_identityType == 'student') _buildConfirmRow(AppStrings.get('grade', lang), _grade ?? '', fontFamily),
                      if (_identityType == 'student') const Divider(color: Colors.white10, height: 32),
                      _buildConfirmRow(AppStrings.get('chinese_name', lang), _cnNameController.text, 'Orbitron'),
                      const Divider(color: Colors.white10, height: 32),
                      _buildConfirmRow(AppStrings.get('english_name', lang), _enNameController.text, 'Orbitron'),
                    ] else ...[
                      _buildConfirmRow(AppStrings.get('child1_name', lang), '${_child1CnController.text} (${_child1Grade})', fontFamily),
                      if (_childCount > 1) ...[
                         const Divider(color: Colors.white10, height: 32),
                        _buildConfirmRow(AppStrings.get('child2_name', lang), '${_child2CnController.text} (${_child2Grade})', fontFamily),
                      ]
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Consumer<ReservationProvider>(
            builder: (context, provider, _) {
              return NeonButton(
                text: AppStrings.get('submit', lang),
                isLoading: provider.isLoading,
                onPressed: _submit,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value, String fontFamily) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: fontFamily)),
      ],
    );
  }
}
