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
        <div>
            <v-row>
                <v-col align="center">
                    <v-card width="300px" class="my-5">
                        <v-card-text> Hello! 
                            {{ username }}
                        </v-card-text>
                        <v-card-text>
                            Dinero para gastar {{ money_display }}
                        </v-card-text>
                    </v-card>
                </v-col>
            </v-row>
        </div>

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
    name: "Users",
    data() {
        return {
            // array that store the store characters of the user
            personajes_usuario:[],

            usuarios:[

            ],
            post: '',

            // username is the variable where we store the parameters that
            // we recive from the path 
            username: '',

            // variable that control the function to play the game and
            // recive rewards
            ready_to_play: false,
            coin_rewads: '',
            shadow_hizzard_money_gang: false,

            // this variable are going to display as the final result from the match
            money_display: '',
            personaje_que_juega:'',
            dano_tomado: '',
            poder_hecho: '',
        }
    },
    created() {
        // we store the value from the parameter that we recive as a id from a data 
        // string type
        this.username = this.$route.params.id;
        this.get_billetera();
        this.llenar_personajes_juego();
    }, 
    methods: {
        async get_billetera() { 
            const money_get = (await this.axios.get('billetera/mi_belletera' + this.$route.params.id)).data;
            let no_money = money_get.map( newmoney => {
                return newmoney.bil_amount;
            })        
            this.money_display = no_money[0];
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
            return;
        },
        goto_market() {
            router.push({path: '/market/'+this.username});
        },

        goto_arsenal() {
            router.push({path: '/arsenal/'+this.username});
        },  
        no_game() {
            this.ready_to_play = false;
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
        }
    },
    components: { router },
}
</script>


