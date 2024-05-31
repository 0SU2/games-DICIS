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
            :headers="encabezados"
            :items="arsenales"
            :items-per-page="5"
            class="elevation-1"
        >
            <template v-slot:top>
                <v-toolbar flat>
                    <v-toolbar-title>Mis Arsenales</v-toolbar-title>
                    <v-spacer></v-spacer>
                </v-toolbar>
            </template>

            <template v-slot:[`item.actions`]="{ item }">
                <v-icon @click="menu_edit = true, llenar_arsenal_especifico(item)" small>
                    fas fa-edit
                </v-icon>
            </template>
        </v-data-table>

        <v-dialog v-model="menu_edit" max-width="500px">
            <v-card>
                <v-card-title>Editar Arsenal</v-card-title>
                <v-card-text>
                    <v-data-table
                        :headers="encabezados_especifico"
                        :items="arsenal_especifico"
                        :items-per-page="5"
                    >
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-icon @click="eliminar_arsenal(item)" small>
                            fa-solid fa-trash
                        </v-icon>
                    </template>
                    </v-data-table>
                </v-card-text>
                <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="error" @click="cancelar()">Cancelar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="eliminados_bien" max-width="500px">
            <v-card>
                <v-card-title>Se realizo la eliminacion!</v-card-title>
                <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="Success" @click="reload_pagina()">Aceptar</v-btn>
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
                    Cerrar sesion
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
                <v-container>
                    <v-card-text>
                        Personaje con el que quieres jugar: 
                        <v-autocomplete
                            :items="personajes_usuario"
                            label="Selecciona"
                            v-model="personaje_que_juega"
                        >
                        </v-autocomplete>
                    </v-card-text>
                </v-container>
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
                    <v-container>Tu personaje {{ personaje_que_juega }} recibio de daño: {{ dano_tomado }}</v-container>
                    <v-container>Tu personaje {{ personaje_que_juega }} realizo de poder: {{ poder_hecho }}</v-container>
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

  export default {
    name: 'Arsenal',
    data() {
        return {
        encabezados: [
            {text: 'Personaje', value: 'asi_per_name'},
            {text: 'Armas', value: 'ars_armas'},
            {text: 'Accesorios', value: 'ars_accesorios'},
            {text: 'Acciones', sortable:false, value: 'actions'},
        ],

        encabezados_especifico: [
            {text: 'Arma', value: 'ars_arm_name'},
            {text: 'Accesorio', value: 'ars_acc_name'},
            {text: 'Acciones', sortable:false, aligncenter: true, value: 'actions'},
        ],

        arsenales: [],
        arsenal_especifico: [],

        menu_edit: false,
        menu_partida: false,

        eliminados_bien: false,

        // username is the variable where we store the parameters that
        // we recive from the path 
        username: '',

        // variable that control the function to play the game and
        // recive rewards
        ready_to_play: false,
        coin_rewads: '',
        shadow_hizzard_money_gang: false,

        // this variable are going to display as the final result from the match
        personaje_que_juega:'',
        dano_tomado: '',
        poder_hecho: '',

        nuevo_arsenal: {
            ars_personaje: '',
            ars_armas: '',
            ars_accesorios: ''
        }
        }
    },

    created(){
        this.username = this.$route.params.id;
        this.llenar_arsenal();
        this.llenar_personajes_juego();
    },

    methods: {
        async llenar_arsenal(){
            const usu_name = this.username;
            const api_data = await this.axios.get('arsenal/todos_los_arsenales' + usu_name);
            this.arsenales = api_data.data;
        },

        cancelar() {
            this.menu_edit = false;
        },

        async llenar_arsenal_especifico(item) {           
            const per_name = item.asi_per_name;
            const usu_name = this.username;
            const api_data = await this.axios.get('arsenal/arsenal_especifico', {params: {per_name, usu_name}});
            this.arsenal_especifico = api_data.data;
        },

        async eliminar_arsenal(item){
            this.eliminados_bien = true;
            const body = item.ars_id;
            const armas_accesorios = (await this.axios.get('arsenal/datos_especificos' + body)).data;
            const arma_arsenal = armas_accesorios.map( elemeto => {
                return elemeto.ars_arm_name;
            })[0];
            const accesorio_arsenal = armas_accesorios.map( elemeto => {
                return elemeto.arsars_acc_name;
            })[0];
            
            const precio_arma = ((await this.axios.get('armas/precio_arma'+arma_arsenal)).data).map( prueba => {
                    return prueba.arm_price;
                })[0];
            const precio_accesorio = ((await this.axios.get('accesorios/precio_accesorio'+accesorio_arsenal)).data).map( prueba => {
                return prueba.acc_price;
            })[0];

            const username = this.$route.params.id;
            const total_a_pagar = (precio_accesorio + precio_arma).toString();      

            await this.axios.get('billetera/agregar_dinero_billetera', {params: {username, total_a_pagar}});

            await this.axios.delete('arsenal/eliminar_arsenal' + body);

            return;
        },

        async jugar_partida(){
            const efectivo = parseInt(Math.random()*100);
        },

        // function that fill the data stored from the characters that the user have
        async llenar_personajes_juego() {
            const api_data = (await this.axios.get('asignaciones/mis_personajes'+this.$route.params.id)).data;
            let pruebas_lol = api_data.map( pruebas => {
                return pruebas.asi_per_name
            })
            this.personajes_usuario = pruebas_lol
        },

        // functions that help to move between pages
        goto_main() {
            router.push({path: '/'});
        },
        goto_personajes(){
            router.push({path: '/personajes/'+this.username});
        },
        // as the same view, we do nothing 
        goto_inicio() {
            router.push({path: '/users/'+this.username});
        },
        goto_market() {
            router.push({path: '/market/'+this.username});
        },

        goto_arsenal() {
            return;
        },  
        no_game() {
            this.ready_to_play = false
        },
        

        // function to start playing the game and 
        // earn money or losing health in each caracter
        async play_game() {
            const username = this.username;
            // variable that tell us who much the player can win
            const max = 1000;

            // variable that tell us who much damage takes the character
            const dano_max = 100;

            // variable that tell us who much power maked the character during the match
            const power_max = 100;

            // we obtain de money that the user adquired
            this.coin_rewads = Math.floor(Math.random() * max);
            this.dano_tomado = Math.floor(Math.random() * dano_max);
            this.poder_hecho = Math.floor(Math.random() * power_max);
            
            const new_money = this.coin_rewads;
            
            await this.axios.get('billetera/agregar_dinero_billetera', {params: {username, new_money}})

            
            // we show all the information that we adqueried during the match
            this.shadow_hizzard_money_gang = true;
            this.ready_to_play = false;
            
            return  
        },
        exit_game () {
            this.shadow_hizzard_money_gang = false;
            location.reload()
        },
        reload_pagina() {
            this.eliminados_bien= false;
            location.reload();
            return;
        }
    },
    components: { router },
  }
</script>