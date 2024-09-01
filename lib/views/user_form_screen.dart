import 'package:flutter/material.dart';
import 'package:flutter_prixz/view_models/user_form_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const List<String> _genres = ['Masculino', 'Femenino'];

class UserFormScreen extends StatelessWidget {
  const UserFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        title: const Text("Usuario"),
      ),
      body: Consumer<UserFormViewModel>(
        builder: (context, c, _) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: c.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: c.namesController,
                      decoration: const InputDecoration(labelText: "Nombres", border: OutlineInputBorder()),
                      enabled: c.status != StatusUserForm.saved,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese los nombres';
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Solo se permiten letras';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: c.lastnamesController,
                      decoration: const InputDecoration(labelText: "Apellidos", border: OutlineInputBorder()),
                      enabled: c.status != StatusUserForm.saved,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese los apellidos';
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Solo se permiten letras';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: c.telephoneController,
                      decoration: const InputDecoration(labelText: "Teléfono", border: OutlineInputBorder()),
                      enabled: c.status != StatusUserForm.saved,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el número de teléfono';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Ingrese un teléfono válido (10 números)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: c.mailController,
                      decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                      enabled: c.status != StatusUserForm.saved,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                          return 'Ingrese un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    if(c.status != StatusUserForm.saved)
                    ListTile(
                      title: Text(
                        c.birthdate == null
                            ? 'Seleccione su fecha de nacimiento'
                            : 'Fecha de nacimiento\n${DateFormat.yMMMMd("es-MX").format(c.birthdate!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: c.birthdate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          locale: const Locale('es', 'MX')
                        );
                        if (fechaSeleccionada != null) c.ageCal(fechaSeleccionada);
                      },
                    ),
                    if (c.age != null) ...[
                      const SizedBox(height: 8,),
                      Text('Edad: ${c.age} años'),
                      const SizedBox(height: 8,),
                    ],
                    const SizedBox(height: 8,),
                    DropdownButtonFormField<String>(
                      value: c.gender,
                      items: _genres.map((String genero) {
                        return DropdownMenuItem<String>(
                          value: genero,
                          child: Text(genero),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: "Género", border: OutlineInputBorder()),
                      onChanged: c.status == StatusUserForm.saved ? null : (value) {
                        c.setGender(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Seleccione un género';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (c.formKey.currentState!.validate()) {
                          if(c.status == StatusUserForm.edit || c.status == StatusUserForm.idle) {
                            c.setStatus(StatusUserForm.saved);
                            final sb = ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Formulario guardado con éxito')),
                            );
                            Future.delayed(const Duration(seconds: 2), () => sb.close(),);
                          } else if(c.status == StatusUserForm.saved) {
                            c.setStatus(StatusUserForm.edit);
                          }
                        }
                      },
                      child: Text(c.status == StatusUserForm.saved ? "Editar" : "Guardar"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}