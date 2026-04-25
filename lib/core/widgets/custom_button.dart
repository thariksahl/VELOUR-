import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../theme/text_styles.dart';

/// A gradient primary CTA button — pill-shaped with luxury gradient fill.
/// Also supports secondary (outlined) and ghost variants.
enum VelourButtonVariant { primary, secondary, ghost, danger }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = VelourButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = AppSizes.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final VelourButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case VelourButtonVariant.primary:
        return _PrimaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          icon: icon,
          width: width,
          height: height,
        );
      case VelourButtonVariant.secondary:
        return _SecondaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          icon: icon,
          width: width,
          height: height,
        );
      case VelourButtonVariant.ghost:
        return _GhostButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          icon: icon,
          width: width,
          height: height,
        );
      case VelourButtonVariant.danger:
        return _DangerButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          width: width,
          height: height,
        );
    }
  }
}

// ─── Primary (gradient pill) ───────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.width,
    required this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.5),
                    AppColors.primaryContainer.withValues(alpha: 0.5),
                  ],
                )
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.onPrimary),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: AppColors.onPrimary, size: 18),
                          const SizedBox(width: AppSizes.sm),
                        ],
                        Text(
                          label.toUpperCase(),
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Secondary (outlined) ─────────────────────────────────────────────────
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.width,
    required this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          foregroundColor: AppColors.onSurface,
          backgroundColor: AppColors.surfaceContainerLowest,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: AppSizes.sm),
                  ],
                  Text(
                    label.toUpperCase(),
                    style: AppTextStyles.buttonLabel,
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Ghost (text-only) ────────────────────────────────────────────────────
class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    required this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.tertiary),
              const SizedBox(width: AppSizes.xs),
            ],
            Text(
              label,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Danger ───────────────────────────────────────────────────────────────
class _DangerButton extends StatelessWidget {
  const _DangerButton({
    required this.label,
    required this.onPressed,
    this.width,
    required this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.errorContainer,
          foregroundColor: AppColors.error,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.buttonLabel.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
