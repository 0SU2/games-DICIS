<template>
    <v-container
        class="my-5"
    >
        <v-row justify="center">
            <v-col
                cols="12"
                sm="10"
                md="8"
                lg="6"
            >
                <v-card ref="form">
                <v-card-text>
                    <v-text-field
                        v-model="nuevo_usuario.usu_username"
                        :rules="[() => !!nuevo_usuario.usu_username || 'This field is required']"
                        label="Usuario"
                        required
                        :error-messages="ErrorSC"
                        @keydown.enter="log_in()"
                        @keydown="restrictSpecialCharacters"
                        ></v-text-field>
                        <v-text-field
                        v-model="nuevo_usuario.usu_email"
                        :rules="[() => !!nuevo_usuario.usu_email || 'This field is required']"
                        label="Correo"
                        required
                        :error-messages="ErrorSC"
                        @keydown.enter="log_in()"
                        @keydown="restrictSpecialCharacters"
                    ></v-text-field>
                    <v-text-field
                        v-model="nuevo_usuario.usu_password"
                        :append-icon="show3 ? 'mdi-eye' : 'mdi-eye-off'"
                        :type="show3 ? 'text' : 'password'"
                        :rules="[() => !!nuevo_usuario.usu_password || 'This field is required']"
                        label="password"
                        hint="At least more than 8 characters"
                        required
                        @click:append="show_password()"
                        :error-messages="ErrorSC"
                        @keydown.enter="log_in()"
                        @keydown="restrictSpecialCharacters"
                    ></v-text-field>
                    <v-menu
                        v-model="menu2"
                        :close-on-content-click="false"
                        :nudge-right="40"
                        transition="sacle-transition"
                        offset-y
                        min-width="290px"
                    >
                        <template
                            v-slot:activator="{on,attrs}"
                        >
                            <v-text-field
                                v-model="nuevo_usuario.usu_birthday"
                                label="Cumpleaños"
                                prepend-icon="far fa-calendar"
                                readonly
                                v-bind="attrs"
                                v-on="on"
                            >
                            </v-text-field>
                        </template>
                        <v-date-picker
                            v-model="nuevo_usuario.usu_birthday"
                            @input="menu2 = false"
                        >

                        </v-date-picker>
                    </v-menu>
                    <v-autocomplete
                    :rules="[() => !!nuevo_usuario.usu_region || 'This field is required']"
                    :items="countries"
                    label="Region"
                    v-model="nuevo_usuario.usu_region"
                    placeholder="Select..."
                    required
                    ></v-autocomplete>
                </v-card-text>
                
                <v-divider class="mx-4 "></v-divider>
                <v-card-actions class="my-2">
                    <v-btn 
                        class="mx-1"
                        color="#f93939"
                        @click="goto_login()"
                    >
                    Cancel
                    </v-btn>
                    <v-btn
                        class="mx-3"
                    color="success"
                    @click="guardar()"
                    >
                    Submit
                    </v-btn>
                </v-card-actions>
                </v-card>
            </v-col>
        </v-row>
        <v-dialog
            max-width="280px"
            v-model="no_existe"
        >
            <v-card>
                <v-spacer></v-spacer>
                <v-card-text
                    class="text-center "
                >
                    <v-container> Porfavor ingrese bien los datos.</v-container>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="error" @click="no_existe = false" center>Cerrar</v-btn>
                </v-card-actions>
            </v-card>

        </v-dialog>

    </v-container>
    
  </template>

<script>
import router from '@/router';
    export default {
        name: 'register',
        data() {
            return {
                // variable with empty data just to verify
                verify_user:{
                    usu_username: '',
                    usu_email: '',
                    usu_password: '',
                    usu_birthday: '',
                    usu_region: ''
                },

                countries:[
                    'Norte-America', 
                    'Europa', 
                    'Asia', 
                    'Sur-America', 
                    'Oceania', 
                    'Centro-America', 
                    'Medio-Oriente'
                ],
                nuevo_usuario:{
                    usu_username: '',
                    usu_email: '',
                    usu_password: '',
                    usu_birthday: '',
                    usu_region: ''
                },
                ErrorSC: '',
                show3: false,
                menu2: false,
                no_existe: false

            }
        },
        methods: {
            limpiar() {
                this.nuevo_usuario = {};
            },
            async guardar() {
                if(this.nuevo_usuario.usu_username === '' || this.nuevo_usuario.usu_password === '' || this.nuevo_usuario.usu_email === '' || this.nuevo_usuario.usu_region === '' || this.nuevo_usuario.usu_birthday === ''){
                    this.no_existe = true;
                    return;
                }
                await this.axios.post('/usuarios/nuevo_usuario', this.nuevo_usuario);
                const usuario = this.nuevo_usuario.usu_username
                await this.axios.get('billetera/crear_billetera' , {params: {usuario}});
                router.push({path: '/users/'+this.nuevo_usuario.usu_username});
                this.limpiar();
            },
            goto_login(){
                router.push({path: '/'});
                this.limpiar();
            },
            show_password() {
                if(!this.show3){
                    this.show3 = true
                    return;
                }
                this.show3 = false;
            },
            restrictSpecialCharacters (event) {
                // expresion regular que restringe caracteres especiales excepto la ñ
                const regex = /[^A-Za-z0-9ñÑ@._]/g
                if (regex.test(event.key)) {
                    event.preventDefault()
                    this.ErrorSC = 'No se permiten los caracteres especiales'
                } else {
                    this.ErrorSC = ''
                }
            }
        }
    }
</script>
