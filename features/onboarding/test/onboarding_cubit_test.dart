import 'package:feature_flags/feature_flags.dart';
import 'package:feature_onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOnboardingRepository implements OnboardingRepository {
  bool completed = false;
  OnboardingDraft? completedDraft;

  @override
  bool isCompleted() => completed;

  @override
  Future<void> complete(OnboardingDraft draft) async {
    completedDraft = draft;
    completed = true;
  }
}

void main() {
  late _FakeOnboardingRepository repo;
  late OnboardingCubit cubit;

  setUp(() {
    repo = _FakeOnboardingRepository();
    cubit = OnboardingCubit(repository: repo);
  });

  tearDown(() => cubit.close());

  test('starts in editing at the first step', () {
    expect(cubit.state.phase, OnboardingPhase.editing);
    expect(cubit.state.stepIndex, 0);
  });

  test('staff-login profiles include the team step', () {
    cubit.selectType(BusinessType.restaurant);
    expect(cubit.steps, contains(OnboardingStep.team));
  });

  test('single-user profiles skip the team step', () {
    cubit.selectType(BusinessType.quickService);
    expect(cubit.steps, isNot(contains(OnboardingStep.team)));
  });

  test('selecting a type applies that profile defaults', () {
    cubit.selectType(BusinessType.festival);
    expect(cubit.state.draft.type, BusinessType.festival);
    expect(cubit.state.draft.cardEnabled, isFalse);
    expect(cubit.state.draft.taxRate, 0);
  });

  test('next/back move within bounds', () {
    expect(cubit.isFirstStep, isTrue);
    cubit.next();
    expect(cubit.state.stepIndex, 1);
    cubit.back();
    expect(cubit.state.stepIndex, 0);
    cubit.back();
    expect(cubit.state.stepIndex, 0);
  });

  test('finish commits the draft and completes', () async {
    cubit.selectType(BusinessType.restaurant);
    await cubit.finish();
    expect(repo.completedDraft, isNotNull);
    expect(repo.completed, isTrue);
    expect(cubit.state.phase, OnboardingPhase.completed);
  });
}
