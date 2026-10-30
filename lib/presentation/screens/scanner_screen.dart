import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:visitor_management/core/constants/app_colors.dart';
import 'package:visitor_management/presentation/screens/visitor_detail_screen.dart';

import '../../core/constants/app_numbers.dart';
import '../../core/constants/app_strings.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/repositories/visitor_repository.dart';
import '../../domain/usecases/get_visitor_by_id.dart';
import '../bloc/visitor_bloc.dart';
import '../bloc/visitor_event.dart';
import '../bloc/visitor_state.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  static const Duration _errorDuration = Duration(seconds: 2);
  static final RegExp _idPattern = RegExp(r'^[A-Za-z0-9_-]{1,40}$');

  late final MobileScannerController _controller;
  late final GetVisitorById _getVisitorById;

  // Scan lock: set synchronously on the first detection so repeated
  // scanner callbacks cannot trigger a second lookup or navigation.
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );
    _getVisitorById = GetVisitorById(context.read<VisitorRepository>());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy) return;
    _busy = true;

    final raw = capture.barcodes.isEmpty
        ? null
        : capture.barcodes.first.rawValue;
    final id = raw?.trim();

    if (id == null || !_idPattern.hasMatch(id)) {
      await _showError(AppStrings.invalidQr);
      return;
    }

    try {
      final visitor = await _getVisitorById(id);
      if (!mounted) return;

      final bloc = context.read<VisitorBloc>();
      if (bloc.state.visitorById(visitor.id) == null) {
        bloc.add(const LoadVisitors());
        await bloc.stream.firstWhere(
          (s) =>
              s.status == LoadStatus.success || s.status == LoadStatus.failure,
        );
        if (!mounted) return;
      }

      await _controller.stop();
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VisitorDetailScreen(visitorId: visitor.id),
        ),
      );
      if (!mounted) return;

      await _controller.start();
      _busy = false;
    } on AppException catch (e) {
      await _showError(e.message);
    } catch (_) {
      await _showError(AppStrings.somethingWentWrong);
    }
  }

  Future<void> _showError(String message) async {
    if (!mounted) return;
    setState(() => _error = message);
    await Future.delayed(_errorDuration);
    if (!mounted) return;
    setState(() => _error = null);
    _busy = false;
  }

  Widget _buildCameraError(MobileScannerException error) {
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppNumbers.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: AppNumbers.iconSizeLg,
              color: AppColors.error,
            ),
            const SizedBox(height: AppNumbers.spaceLg),
            Text(
              denied
                  ? AppStrings.cameraPermissionDenied
                  : AppStrings.cameraError,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (denied) ...[
              const SizedBox(height: AppNumbers.spaceSm),
              const Text(
                AppStrings.cameraPermissionHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: AppNumbers.spaceLg),
            OutlinedButton(
              onPressed: () => _controller.start(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        Center(
          child: IgnorePointer(
            child: Container(
              width: AppNumbers.scanBoxSize,
              height: AppNumbers.scanBoxSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _error == null ? Colors.white : AppColors.error,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(AppNumbers.radiusMd),
              ),
            ),
          ),
        ),
        Positioned(
          left: AppNumbers.spaceLg,
          right: AppNumbers.spaceLg,
          bottom: AppNumbers.spaceXl,
          child: Container(
            padding: const EdgeInsets.all(AppNumbers.spaceMd),
            decoration: BoxDecoration(
              color: _error == null ? Colors.black54 : AppColors.error,
              borderRadius: BorderRadius.circular(AppNumbers.radiusSm),
            ),
            child: Text(
              _error ?? AppStrings.scanHint,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.scanTitle)),
      body: ValueListenableBuilder<MobileScannerState>(
        valueListenable: _controller,
        builder: (context, value, _) {
          final error = value.error;
          if (error != null) return _buildCameraError(error);
          return _buildScanner();
        },
      ),
    );
  }
}
