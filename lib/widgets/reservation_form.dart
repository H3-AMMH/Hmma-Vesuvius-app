import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ReservationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController telController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController partySizeController;
  final bool submitting;
  final VoidCallback onSubmit;

  const ReservationForm({
    required this.formKey,
    required this.nameController,
    required this.telController,
    required this.dateController,
    required this.timeController,
    required this.partySizeController,
    required this.submitting,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            const Text(
              'Opret reservation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Navn',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (v) => v == null || v.isEmpty ? 'Påkrævet' : null,
            ),

            // --- Phone number field using intl_phone_number_input ---
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'DK'),
              onInputChanged: (PhoneNumber number) {
                telController.text = number.phoneNumber ?? '';
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              textStyle: const TextStyle(color: Colors.white),
              inputDecoration: const InputDecoration(
                labelText: 'Telefon',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Påkrævet';
                final digits = value.replaceAll(
                  RegExp(r'\D'),
                  '',
                ); // keep only numbers
                if (digits.length < 8) {
                  return 'Ugyldigt nummer';
                }
              },
            ),

            // --- Date field ---
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.tryParse(dateController.text) ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Colors.brown,
                        onPrimary: Colors.white,
                        surface: Colors.black,
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Dato (YYYY-MM-DD)',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v == null || v.isEmpty ? 'Påkrævet' : null,
                ),
              ),
            ),

            // --- Time field ---
            GestureDetector(
              onTap: () async {
                final initialTime = TimeOfDay.fromDateTime(
                  DateTime.tryParse('1970-01-01 ${timeController.text}') ??
                      DateTime.now(),
                );
                final picked = await showTimePicker(
                  context: context,
                  initialTime: initialTime,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(alwaysUse24HourFormat: true),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.brown,
                            onPrimary: Colors.white,
                            surface: Colors.black,
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                  },
                );
                if (!context.mounted) return;
                if (picked != null) {
                  final dt = DateTime(1970, 1, 1, picked.hour, picked.minute);
                  timeController.text = DateFormat('HH:mm').format(dt);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Tid',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v == null || v.isEmpty ? 'Påkrævet' : null,
                ),
              ),
            ),

            // --- Party size field ---
            TextFormField(
              controller: partySizeController,
              decoration: const InputDecoration(
                labelText: 'Antal personer',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Påkrævet';
                final n = int.tryParse(v);
                if (n == null || n < 1) return 'Ugyldigt antal';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitting ? null : onSubmit,
              child: submitting
                  ? const CircularProgressIndicator()
                  : const Text('Opret reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
