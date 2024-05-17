<template>
    <v-container>
        <template>
            <v-container
                class="d-flex justify-center "
            >
                <v-btn
                    class="mx-2"
                    @click="goto_personajes()"
                >Personajes</v-btn>
                <v-btn
                    class="mx-4"
                    @click="goto_inicio()"
                >
                    Home
                </v-btn>
                <v-btn 
                    @click="goto_market()"
                >
                    Mercado
                </v-btn>
                <v-btn
                    class="mx-5"
                    @click="goto_arsenal()"
                >
                    Arsenal
                </v-btn>
            </v-container>
        </template>
        <v-data-table
        :headers = "encabezados"
        :items = "personajes"
        :items-per-page="5"
        class="elevation-1">
        <template v-slot:top>
                <v-toolbar flat>
                    <v-toolbar-title>Personajes</v-toolbar-title>
                    <v-spacer></v-spacer>
                    <v-btn color="#B5EBF9" @click="nmp_dialog = true;" class="mr-3">Mis personajes</v-btn>
                    <v-card-actions>
                        <v-btn color="#B5EBF9" @click="np_dialog = true;">Agregar Personaje</v-btn>
                    </v-card-actions>
                </v-toolbar>
        </template>
        </v-data-table>

        <v-dialog v-model="np_dialog" max-width="500px">
                <v-card>
                    <v-card-title>Agregar Personajes</v-card-title> 
                    <v-card-text>
                        <v-container>
                            <v-row>
                                <v-col cols="12">
                                    <v-select
                                    :items="personajes_agregar"
                                    v-model="nueva_asignacionPsj.asi_per_name"
                                    label="Nombre del personaje">
                                    </v-select>
                                </v-col>
                            </v-row>
                            <v-row>
                            <v-col cols="6">
                                <v-menu
                                    v-model="menu1"
                                    :close-on-content-click="false"
                                    :nudge-right="40"
                                    transition="scale-transition"
                                    offset-y
                                    min-width="290px"
                                >
                                    <template v-slot:activator="{on,attrs}">
                                        <v-text-field
                                        v-model="nueva_asignacionPsj.asi_date_created"
                                        label="Fecha de creacion"
                                        prepend-icon="far fa-calendar"
                                        readonly 
                                        v-bind="attrs"
                                        v-on="on"
                                        >
                                        </v-text-field>
                                    </template>
                                <v-date-picker
                                    v-model="nueva_asignacionPsj.asi_date_created"
                                    @input="menu1=false">
                                </v-date-picker>
                                </v-menu>
                            </v-col>

                            <v-col cols="6">
                                <v-menu
                                v-model="menu2"
                                :close-on-content-click="false"
                                transition="scale-transition"
                                offset-y
                                min-width="290px"
                                >
                                <template v-slot:activator="{on,attrs}">
                                    <v-text-field
                                    v-model="nueva_asignacionPsj.asi_time_created" 
                                    label="Hora de creación"
                                    readonly 
                                    v-bind="attrs"
                                    v-on="on"
                                    >   
                                    </v-text-field>
                                    </template>
                                    <v-time-picker
                                    v-model="nueva_asignacionPsj.asi_time_created"
                                    @input="menu2=false">
                                    </v-time-picker>
                                </v-menu>
                                    
                                
                            </v-col>
                        </v-row>
                        </v-container>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn color="error" @click="cancelar()">Cancelar</v-btn>
                        <v-btn color="success" @click="guardar_personajesAsg()">Guardar</v-btn>
                    </v-card-actions>
                   
                </v-card>

        </v-dialog>
            <v-dialog v-model="nmp_dialog" max-width="600px"> 
                <v-card>
                    <v-card-title
                    color="#512DA8" >
                        Mis Personajes 
                        <v-spacer></v-spacer>
                    </v-card-title> 
                    <v-car-text>
                        <v-container>
                            <v-data-table
                            :headers = "encabezados2"
                            :items = "asignaciones"
                            :items-per-page="5"
                            class="elevation-1"
                            >
                            <template v-slot:[`item.actions`]="{item}">
                                <v-icon @click="eliminar_personajeAsg(item)" small class="mr-3">
                                    fa-solid fa-trash 
                                </v-icon >
                            </template>
                            </v-data-table>
                        </v-container>
                    </v-car-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn color="error" @click="cancelar()">Regresar</v-btn>
                    </v-card-actions>
                </v-card>
            
            </v-dialog>

        <template>
            <v-container
                class="d-flex justify-center my-3"
            >
                <v-btn
                    @click="goto_main()"
                    class="mx-5"
                >
                    Return to Login
                </v-btn>  
                <v-btn
                    @click="ready_to_play = true"
                    class="mx-5"
                >
                    PLAY GAME!
                </v-btn>  
            </v-container>
        </template>  

        <v-dialog
            max-width="510px"
            v-model="ready_to_play"
            >
            <v-card>
                <v-spacer></v-spacer>
                <v-card-text
                    class="text-center"
                >
                    <v-container>¿Preparado para jugar {{ username }}? </v-container>
                </v-card-text>

                <v-card-actions>
                    <v-btn color="error" @click="no_game()" center>Cerrar</v-btn>
                    <v-btn color="success" @click="play_game()" center>Continuar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog
            max-width="510px"
            v-model="shadow_hizzard_money_gang"
            >
            <v-card>
                <v-spacer></v-spacer>
                <v-card-text
                    class="text-center"
                >
                    <v-container>Monedas conseguidas: {{ coin_rewads }}</v-container>
                </v-card-text>

                <v-card-actions>
                    <v-btn color="error" @click="exit_game()" center>Cerrar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

    </v-container>

</template>

<script>
import router from '@/router';
    export default({
            name: 'personajes',

            data(){
                return{
                    encabezados: [ //Personajes 
                    {text: 'Nombre', sortable:false, value:'per_name'},
                    {text: 'Clase', value:'per_class'},
                    {text: 'Vida', value:'per_health'},
                    {text: 'Armadura', value:'per_armor'}
                    ],

                    encabezados2: [ // Mis personajes (asignacion)
                    //{text: 'Nombre usuario', value:'asi_usu_username'},
                    {text: 'Nombre personaje', value:'asi_per_name'},
                    {text: 'Fecha Creacion', value:'asi_date_created'},
                    {text: 'Hora de creacion', value:'asi_time_created'},
                    {text: 'Eliminar', sortable: false, value: 'actions'}
                    ],
                    

                    personajes: [], //arreglo con los datos de personajes 
                    asignaciones: [], //arreglo con los datos de asignacion
                    //det_asignacion: [], 

                    personajes_agregar: [], //controla los personajes para cada usuario(asignacion)
                    
                    menu1: false, // Implementa el calendario
                    menu2: false, // Implementa el reloj 

                    asi_id:'',
                    

                    np_dialog: false, //Personajes 
                    nmp_dialog: false, //Mis personajes 
                
                    //Agregar personajes al usuario(asignacion)
                    nueva_asignacionPsj:{ 
                        asi_usu_username:'', 
                        asi_per_name:'',
                        asi_date_created:'',
                        asi_time_created:'' 
                    },

                    // username is the variable where we store the parameters that
                    // we recive from the path 
                    username: '',

                    // variable that control the function to play the game and
                    // recive rewards
                    ready_to_play: false,
                    coin_rewads: '',
                    shadow_hizzard_money_gang: false
                }   
            },
               
            created(){
                this.llenar_personajes();
                this.llenar_asignacion();
                this.llenar_personajesAsg();
                this.username = this.$route.params.id
            },
            methods: {
                // Muestra todos los personajes existentes en la pagina principal
                async llenar_personajes(){ 
                    this.personajes = (await this.axios.get('personajes/todos_los_personajes')).data;
                },
                //Muesra la lista de personajes para la asignacion del usuario (agregar personaje)
                async llenar_personajesAsg(){
                    const api_data = await this.axios.get('/personajes/todos_los_personajes');

                    api_data.data.forEach((item) => {
                        this.personajes_agregar.push({
                            text: item.per_name,
                            value: item.per_name
                        })
                    });
                },

                cancelar(){
                    this.nueva_asignacionPsj = {}; //reinicia la ventana Agregar Personaje
                    this.np_dialog = false; //Cierra Agregar Personaje
                    this.nmp_dialog = false; // Cierra Agregar Mis Personajes 
                    //this.det_asignacion = [];
                    this.personajes_agregar= [];
                },

                // muestra los personajes que tiene cada usuario en el boton Mis personajes
                async llenar_asignacion(){
                    const api_data = await this.axios.get('asignaciones/mis_personajes'+ this.$route.params.id); 
                    this.asignaciones = api_data.data;
                    this.asignaciones = this.asignaciones.map(
                        ({asi_id,asi_usu_username,asi_per_name,asi_date_created,asi_time_created}) => ({
                            asi_id:asi_id,
                            asi_usu_username:asi_usu_username,
                            asi_per_name:asi_per_name,
                            asi_date_created: asi_date_created.substring(0,10),
                            asi_time_created:asi_time_created
                        })
                    );
                },

                // Permite eliminar personajes asociados con un usuario en el boton Mis personajes
                async eliminar_personajeAsg(item){
                    const body = {
                        asi_id: item.asi_id
                    };
                    await this.axios.delete('asignaciones/eliminar_asignacion',{data:body});
                    this.llenar_asignacion();
                },
                // Permite agregar nuevo personaje al usuario (asignacion) 
                async guardar_personajesAsg(){
                    //console.log(this.nueva_asignacionPsj);
                    this.nueva_asignacionPsj.asi_usu_username = this.username;
                    
                    const user_name = this.nueva_asignacionPsj.asi_usu_username;
                    const per_name = this.nueva_asignacionPsj.asi_per_name;
                    const date = this.nueva_asignacionPsj.asi_date_created;

                    await this.axios.post('asignaciones/nueva_asignacion', this.nueva_asignacionPsj);
                    this.llenar_asignacion();
                    this.cancelar();
                }, 

                // functions that help to move between pages
                goto_main() {
                    router.push({path: '/'});
                },
                goto_personajes(){
                    return;
                },
                // as the same view, we do nothing 
                goto_inicio() {
                    router.push({path: '/users/'+this.username})
                },
                goto_market() {
                    router.push({path: '/market/'+this.username});
                },

                goto_arsenal() {
                    router.push({path: '/arsenal/'+this.username})
                },  
                no_game() {
                    this.ready_to_play = false
                },
                // function to start playing the game and 
                // earn money or losing health in each caracter
                async play_game() {
                    const max = 1000;
                    this.coin_rewads = Math.floor(Math.random() * max)
                    this.shadow_hizzard_money_gang = true;
                    this.ready_to_play = false;
                    return  
                },
                exit_game () {
                    this.shadow_hizzard_money_gang = false;
                }

                
            }
    })
</script>