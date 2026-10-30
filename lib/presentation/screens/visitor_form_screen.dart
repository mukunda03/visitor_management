import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_management/presentation/screens/visitor_detail_screen.dart';

import '../../core/constants/app_numbers.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/visitor.dart';
import '../bloc/visitor_bloc.dart';
import '../bloc/visitor_event.dart';
import '../bloc/visitor_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class VisitorFormScreen extends StatefulWidget {
  final Visitor? visitor;

  const VisitorFormScreen({super.key, this.visitor});

  @override
  State<VisitorFormScreen> createState() => _VisitorFormScreenState();
}

class _VisitorFormScreenState extends State<VisitorFormScreen> {
  static final RegExp _emailRegex = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _purposeController;

  late String _visitorType;
  late String _project;
  bool _submitting = false;

  bool get _isEdit => widget.visitor != null;

  @override
  void initState() {
    super.initState();
    final v = widget.visitor;
    _nameController = TextEditingController(text: v?.name ?? '');
    _mobileController = TextEditingController(text: v?.mobile ?? '');
    _emailController = TextEditingController(text: v?.email ?? '');
    _purposeController = TextEditingController(text: v?.purpose ?? '');
    _visitorType = AppStrings.visitorTypes.contains(v?.visitorType)
        ? v!.visitorType
        : AppStrings.visitorTypes.first;
    _project = AppStrings.projects.contains(v?.project)
        ? v!.project
        : AppStrings.projects.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String? _validateMobile(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.mobileRequired;
    if (text.length != AppNumbers.mobileLength) return AppStrings.mobileInvalid;
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!_emailRegex.hasMatch(text)) return AppStrings.emailInvalid;
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final existing = widget.visitor;
    final email = _emailController.text.trim();

    final visitor = Visitor(
      id: existing?.id ?? '',
      name: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: email.isEmpty ? null : email,
      visitorType: _visitorType,
      project: _project,
      purpose: _purposeController.text.trim(),
      status: existing?.status ?? AppStrings.statusRegistered,
      createdAt: existing?.createdAt ?? DateTime.now(),
      checkInTime: existing?.checkInTime,
      checkOutTime: existing?.checkOutTime,
    );

    setState(() => _submitting = true);

    final bloc = context.read<VisitorBloc>();
    bloc.add(_isEdit ? UpdateVisitorEvent(visitor) : AddVisitorEvent(visitor));
  }

  void _onResult(BuildContext context, VisitorState state) {
    setState(() => _submitting = false);
    if (state.isError) return;

    final navigator = Navigator.of(context);

    if (_isEdit || state.visitors.isEmpty) {
      navigator.pop();
      return;
    }

    final created = state.visitors.last;
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => VisitorDetailScreen(visitorId: created.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitorBloc, VisitorState>(
      listenWhen: (previous, current) =>
          _submitting && previous.messageId != current.messageId,
      listener: _onResult,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? AppStrings.editVisitor : AppStrings.registerVisitor,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppNumbers.spaceLg),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: AppStrings.visitorName,
                    validator: (v) =>
                        _validateRequired(v, AppStrings.nameRequired),
                  ),
                  const SizedBox(height: AppNumbers.spaceLg),
                  CustomTextField(
                    controller: _mobileController,
                    label: AppStrings.mobileNumber,
                    keyboardType: TextInputType.number,
                    maxLength: AppNumbers.mobileLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validateMobile,
                  ),
                  const SizedBox(height: AppNumbers.spaceLg),
                  CustomTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: AppNumbers.spaceLg),
                  DropdownButtonFormField<String>(
                    initialValue: _visitorType,
                    decoration: _dropdownDecoration(AppStrings.visitorType),
                    items: AppStrings.visitorTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _visitorType = value);
                    },
                  ),
                  const SizedBox(height: AppNumbers.spaceLg),
                  DropdownButtonFormField<String>(
                    initialValue: _project,
                    decoration: _dropdownDecoration(AppStrings.project),
                    items: AppStrings.projects
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _project = value);
                    },
                  ),
                  const SizedBox(height: AppNumbers.spaceLg),
                  CustomTextField(
                    controller: _purposeController,
                    label: AppStrings.purposeOfVisit,
                    textInputAction: TextInputAction.done,
                    validator: (v) =>
                        _validateRequired(v, AppStrings.purposeRequired),
                  ),
                  const SizedBox(height: AppNumbers.spaceXl),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: AppStrings.cancel,
                          isOutlined: true,
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: AppNumbers.spaceMd),
                      Expanded(
                        child: CustomButton(
                          label: AppStrings.save,
                          isLoading: _submitting,
                          onPressed: _save,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppNumbers.radiusSm),
      ),
    );
  }
}
