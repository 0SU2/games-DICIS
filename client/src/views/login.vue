<template>
    <v-container>
        
        <v-card
            class="mx-auto my-12"
            max-width="374"
        >
            <template slot="progress">
                <v-progress-linear
                color="deep-purple"
                height="10"
                indeterminate
                ></v-progress-linear>
            </template>
        
            <v-card-title>Inicio de Sesion</v-card-title>
        
            <v-card-text>
                <v-container>
                    <v-row>
                        <v-col>
                            <v-text-field
                                v-model="usuario.usu_username"
                                outlined
                                label="Username"
                            >
                            </v-text-field>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col>
                            <v-text-field
                                :append-icon="show3 ? 'mdi-eye' : 'mdi-eye-off'"
                                :type="show3 ? 'text' : 'password'"
                                v-model="usuario.usu_password"
                                outlined
                                label="Password"
                                hint="At least more than 8 characters"
                                class="input-group--focused"
                                @click:append="show3 = !show3"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                </v-container>
            </v-card-text>
        
            <v-divider class="mx-4"></v-divider>
            
            <v-card-text
                align="center"
            >
            <v-spacer></v-spacer>
                <v-btn
                    class="mx-5"
                    color="success"
                    @click="log_in()"
                >
                    Continue
                </v-btn>
                <v-btn
                    color="#fff783"
                    @click="goto_register()"
                >
                    Crear cuenta
                </v-btn>
            </v-card-text>
        </v-card>
        <v-dialog
            max-width="510px"
            v-model="no_existe"
        >
            <v-card>
                <v-spacer></v-spacer>
                <v-card-text
                    class="text-center"
                >
                    <v-container> Porfavor ingrese un usuario o contraseña, o bien, ingrese bien la contraseña y el usuario.</v-container>
                </v-card-text>

                <v-card-actions>
                    <v-btn color="error" @click="limpiar()" center>Cerrar</v-btn>
                </v-card-actions>
            </v-card>

        </v-dialog>
        <v-card>
        </v-card>
    </v-container>

</template>


<script>
import router from '@/router';

  export default {
    name: "Login",
    
    data() {
        return {
            usuario:{
                usu_username: '',
                usu_password: '',
            },

            show3: false,
            no_existe: false,
            si_existe: false,
            rules: {
                required: value => !!value || "Required.",
                min: v => v.length >= 8 || "Min 8 characters",
            },
        };
    },
    methods: {
        limpiar() {
            this.usuario.usu_username = '',
            this.usuario.usu_password = '',
            this.no_existe = false
        },
        async log_in() {
            if(this.usuario.usu_password == '' || this.usuario.usu_username == '') {
                this.no_existe = true;
                return;
            }
            const username = this.usuario.usu_username;
            const respuesta = await this.axios.get('/usuarios/busqueda_usuario' + username);
            if(respuesta.data.length === 0) {
                this.no_existe = true;
                return;
            }
            const contrasena = respuesta.data;
            if(contrasena[0].usu_password === this.usuario.usu_password) {
                router.push({path: '/users/' + this.usuario.usu_username});
                return;
            }
            else {
                this.no_existe = true;
            }
        },
        goto_register(){
            router.push({ path: '/register' })
        },
        show_password() { 
            if(!this.show3){
                this.show3 = true
                return;
            }
            this.show3 = false;
        }
    },
    components: { router },
}
</script>

