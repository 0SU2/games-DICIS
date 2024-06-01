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
                    class="mx-5"
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
        :items="armas"
        :items-per-page="5"
        class="elevation-1 my-2"
        >

        <template v-slot:top>
            <v-toolbar flat>
                <v-toolbar-title>Listado de armas</v-toolbar-title>
                <v-spacer></v-spacer>
                <v-toolbar-title>Dinero para gastar {{ money_display }}</v-toolbar-title>
                <v-spacer></v-spacer>
                <v-btn color="#B5EBF9" @click="first_dialog=true">¡Crea tu arsenal!</v-btn>
            </v-toolbar>
        </template>
        </v-data-table>

        <v-dialog v-model="first_dialog" max-width="500">
            <v-card>
                <v-card-title>Selecciona la informacion</v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-select
                                :items="personajes_usuario"
                                label="Personaje"
                                v-model="personaje_seleccionado"
                            >

                            </v-select>
                        </v-row>
                        <v-row>
                            <v-select
                                :items="accesorios_select"
                                label="Accesorio"
                                v-model="accesorios_seleccionado"
                            >

                            </v-select>
                        </v-row>
                        <v-row>
                            <v-select
                                :items="armas_select"
                                label="Armas"
                                v-model="arma_seleccionada"
                            >

                            </v-select>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="success" @click="guardar_seleccion()"> Guardar </v-btn>
                    <v-btn color="error" @click="cancelar()"> Cancelar </v-btn>
                    <v-spacer></v-spacer>
                </v-card-actions>
            </v-card>
        </v-dialog>
        <v-dialog v-model="seguro_de_comprar" max-width="500">
            <v-card>
                <v-card-title>Seguro de continuar</v-card-title>
                <v-card-text> Precio de {{ accesorios_seleccionado }} = {{ precio_accesorio_desplegar }} </v-card-text>
                <v-card-text> Precio de {{ arma_seleccionada }} = {{  precio_arma_desplegar }} </v-card-text>
                <v-card-text> Pago final =  {{ total_a_pagar_seleccion }} </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="success" @click="continuar_compra()"> Seguro </v-btn>
                    <v-btn color="error" @click="cancelar()"> Cancelar </v-btn>
                    <v-spacer></v-spacer>
                </v-card-actions>
            </v-card>
        </v-dialog>
        

        <v-data-table
        :headers="encabezados_2"
        :items="accesorios"
        :items-per-page="5"
        class="elevation-1">

        <template v-slot:top>
            <v-toolbar flat>
                <v-toolbar-title>Listado de accesorios</v-toolbar-title>
                <v-spacer></v-spacer>
            </v-toolbar>
        </template>

        </v-data-table>

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
        name: 'armas',

        data() {
            return{
                encabezados: [
                    // declaramos el conjunto de OBJETOS con sus respectivas conjunto de entidadas,
                    // es decir, los atributos que nos mostraran la tabla en forma de arreglo:
                    { /*O B J E T O   1 ---> */ text: 'Nombre', sortable : false, value: 'arm_name'}, // el Nombre se asocia a un valor dentro de la variable, en este caso 'arm_name'
                    { /*O B J E T O   2 ---> */ text: 'Tipo', value: 'arm_type'},
                    { /*O B J E T O   3 ---> */ text: 'Precio', value: 'arm_price'},
                    { /*O B J E T O   4 ---> */ text: 'Velocidad', value: 'arm_speed'},
                    { /*O B J E T O   5 ---> */ text: 'Cadencia', value: 'arm_cadences'},
                    { /*O B J E T O   6 ---> */ text: 'Daño', value: 'arm_damage'},
                    { /*O B J E T O   7 ---> */ text: 'Cartucho', sortable: false, value: 'arm_mags'},

                ],
                
                // Segundo Encabezado:
                encabezados_2: [
                    // Ahora para los datos de la tala de accesorios:
                    { /*O B J E T O   1 ---> */ text: 'Nombre', sortable : false, value: 'acc_name'}, // el Nombre se asocia a un valor dentro de la variable, en este caso 'arm_name'
                    { /*O B J E T O   2 ---> */ text: 'Defensa', value: 'acc_defenses'},
                    { /*O B J E T O   3 ---> */ text: 'Parte del Cuerpo', sortable: false, value: 'acc_body_part'},
                    { /*O B J E T O   4 ---> */ text: 'Precio', value: 'acc_price'}
                ],

                // Variable que se encarga de leer los datos de la base de datos:
                armas: [
                    // En forma de arreglo vacio, por que adelante en el aparato de metodos, hacemos la preticion
                ],

                // Declaramos la variable que se encarga de leer los registros de la base de datos:
                accesorios: [/* arreglo vacio se declaran en los metodos*/],

                accesorios_select: [],
                armas_select: [],

                // Creamos un aparato de dialog para el NUEVO BOTON de 'CHECA TUS ARMAS' creando:
                first_dialog: false,  // Para cuando se corrobore las armas conforme a cada tipo de personaje
                second_dialog: false,
                seguro_de_comprar: false,
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
                // array that store the store characters of the user
                personajes_usuario:[],

                // variable that store the new accessory
                accesorios_seleccionado: '',
                arma_seleccionada: '',
                personaje_seleccionado: '',
                precio_accesorio_desplegar: '',
                precio_arma_desplegar: '',
                total_a_pagar_seleccion: ''
            }

            // Variable que se pasa para hacer una peticion para guardar en nuestra base de datos 
        },

        // Hacemos una funcion para cerar metodos que se ejecuten en su ciclo de vida
        created(){
            // Es decir, conjunto de métodos que se va a llamar cuando la vista se gener
            this.llenar_armas();
            
            // Segunda funcion de llamada para el conjunto de metodos de accesorios:
            this.llenar_accesorios();

            this.username = this.$route.params.id;

            // functions that we create to get the money and fill the characters
            this.get_billetera();
            this.llenar_personajes_juego();

            this.llenar_accesorios_2();
        },

        // Apartado de metodos o FUNCIONES:
        methods: {
            // Funcion 1 para mostrar todas las armas:
            async llenar_armas() {
                const api_data = await this.axios.get('armas/todas_las_armas'); // Se hace una de las 4 peticiones 'get', de la cual pasamos el parametro la RUTA DE LA PETICION
                // Con esto devolvemos las armas en formato  JDON en funcion de armas.js en res.json(armas).
                // Api_data nos guarla la peticion

                // Obtenemos el arreglo de los objetos 'json' con:
                this.armas = api_data.data;
            },

            // Funcion 2: BOTON DE CANCELAR para eleccion de arma:
            async cancelar(){
                this.first_dialog = false;
                this.seguro_de_comprar = false;
            },

            // Funcion o Método 3, para obtener los accesorios de la base de datos:
            async llenar_accesorios() {
                const api_data = await this.axios.get('accesorios/todos_los_accesorios'); // Se realiza peticion get
                // ASi devolvemos los accesorios en formato JSON del archivo accesorios.js

                // Obtenemos el arreglo de objetos 'json0' con:
                this.accesorios = api_data.data;

            },
            
            // function that i created for the seleccion
            async llenar_accesorios_2() {
                const pruebas = (await this.axios.get('accesorios/todos_los_accesorios')).data;
                const arma_todas = (await this.axios.get('armas/todas_las_armas')).data;
                const otra_prueba = pruebas.map( pruebas => {
                    return pruebas.acc_name;
                });
                const armas_para_elegir = arma_todas.map( pruebas => {
                    return pruebas.arm_name;
                });
                this.accesorios_select = otra_prueba;
                this.armas_select = armas_para_elegir;
            },

            async guardar_seleccion() {
                
                const arma_elegida = this.arma_seleccionada;
                const accesorio_elegido = this.accesorios_seleccionado;
                const username = this.username
                const character = this.personaje_seleccionado;


                const precio_accesorio = ((await this.axios.get('accesorios/precio_accesorio'+accesorio_elegido)).data).map( prueba => {
                    return prueba.acc_price;
                })[0];
                const precio_arma = ((await this.axios.get('armas/precio_arma'+arma_elegida)).data).map( prueba => {
                    return prueba.arm_price;
                })[0];
                const id_asignacion = ((await this.axios.get('asignaciones/obtener_id_asignacion', {params: {username, character}})).data).map( elementos => {
                    return elementos.asi_id;
                })[0].toString();



                this.precio_accesorio_desplegar = precio_accesorio;
                this.precio_arma_desplegar = precio_arma;

                const total_a_pagar = (precio_accesorio + precio_arma).toString();
                this.total_a_pagar_seleccion = total_a_pagar;

                this.seguro_de_comprar = true;
                
            },

            async continuar_compra() {
                const arma_elegida = this.arma_seleccionada;
                const accesorio_elegido = this.accesorios_seleccionado;
                const username = this.username
                const character = this.personaje_seleccionado;
                const currentdate = new Date();
                var datetime = currentdate.getFullYear() + '-' + currentdate.getMonth() + '-' +  currentdate.getDate()  + ' '
                                currentdate.getHours() + ':' + currentdate.getMinutes() + ':' + currentdate.getSeconds();


                const precio_accesorio = ((await this.axios.get('accesorios/precio_accesorio'+accesorio_elegido)).data).map( prueba => {
                    return prueba.acc_price;
                })[0];
                const precio_arma = ((await this.axios.get('armas/precio_arma'+arma_elegida)).data).map( prueba => {
                    return prueba.arm_price;
                })[0];
                const id_asignacion = ((await this.axios.get('asignaciones/obtener_id_asignacion', {params: {username, character}})).data).map( elementos => {
                    return elementos.asi_id;
                })[0].toString();


                this.seguro_de_comprar = false;
                const total_a_pagar = (precio_accesorio + precio_arma).toString();
                await this.axios.get('billetera/decrementar_dinero_billetera', {params: {username, total_a_pagar}});
                
                await this.axios.get('arsenal/nuevo_arsenal', {params: {id_asignacion, accesorio_elegido, arma_elegida, total_a_pagar, datetime}});

                location.reload()
            },

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
                router.push({path: '/users/'+this.username});
            },
            goto_market() {
                return
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