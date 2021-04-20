import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ethanolController = TextEditingController();
  TextEditingController gasolineController = TextEditingController();

  String _tipChosen = "Irei rodar em:";
  String _info = "Complete os campos acima...";
  String _winner = "";

  double _proportionCityBravoEssence2013Dualogic = (6.4 / 8.9) - (1 / 100);
  double _proportionRoadBravoEssence2013Dualogic = (7.5 / 10.9) - (1 / 100);

  bool _typeOfRoad;
  Color _iconColor = Colors.black;
  Color _icon2Color = Colors.black;

  void _refresh() {
    ethanolController.text = "";
    gasolineController.text = "";
    _winner = "";
    _iconColor = Colors.black;
    _icon2Color = Colors.black;
    _typeOfRoad = null;
    setState(() {
      _formKey = GlobalKey<FormState>();
      _tipChosen = "Irei rodar em:";
      _info = "Complete os campos acima...";

    });
  }

  void _calculate() {
    setState(() {
      double _valorEthanol = double.parse(ethanolController.text);
      double _valorGasoline = double.parse(gasolineController.text);
      String _proportionCarChosen;

      if (!_typeOfRoad) {
        if (_valorEthanol / _valorGasoline - 0.01 <=
            _proportionCityBravoEssence2013Dualogic) {
          _winner = "ETANOL";
        } else {
          _winner = "GASOLINA";
        }
        _proportionCarChosen =
            _proportionCityBravoEssence2013Dualogic.toStringAsPrecision(2);
      } else {
        if (_valorEthanol / _valorGasoline - 0.01 <=
            _proportionRoadBravoEssence2013Dualogic) {
          _winner = "ETANOL";
        } else {
          _winner = "GASOLINA";
        }
        _proportionCarChosen =
            _proportionRoadBravoEssence2013Dualogic.toStringAsPrecision(2);
      }
      _info = "$_winner é mais vantajoso\n\n"
          "Referência:\n"
          "Etanol <= $_proportionCarChosen > Gasolina\n\n"
          "Etanol / Gasolina - 1% = "
          "${(_valorEthanol / _valorGasoline - 0.01).toStringAsPrecision(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de Combustível"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _refresh();
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _tipChosen,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [


                        IconButton(
                          icon: Icon(
                            Icons.location_city,
                          ),
                          iconSize: 30,
                          color: _iconColor,
                          onPressed: () {
                            //false == city
                            this._typeOfRoad = false;
                            setState(() {
                              _iconColor = Colors.red;
                              _icon2Color = Colors.black;
                              _tipChosen = "Irei rodar em Cidade";
                            });
                          },
                          //mensagem ao pressionar
                          tooltip: "Cidade",
                        ),


                        Text("Cidade"),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                    Column(
                      children: [
                        Icon(Icons.directions_car,
                            color: Colors.blueGrey, size: 120),
                        Text(
                          "bravo absolute 2013",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_road),
                          iconSize: 30,
                          color: _icon2Color,
                          onPressed: () {
                            this._typeOfRoad = true;
                            setState(() {
                              _iconColor = Colors.black;
                              _icon2Color = Colors.red;
                              _tipChosen = "Irei rodar em Estrada";
                            });
                          },
                          //mensagem ao pressionar
                          tooltip: "Estrada",
                        ),
                        Text("Estrada"),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  decoration: InputDecoration(
                    labelText: "Etanol",
                    labelStyle: TextStyle(color: Colors.blueGrey),
                  ),
                  controller: ethanolController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira o preço do Etanol!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  decoration: InputDecoration(
                    labelText: "Gasolina",
                    labelStyle: TextStyle(color: Colors.blueGrey),
                  ),
                  controller: gasolineController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira o preço da Gasolina!";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 25),
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                        child: Text(
                          "Calcular",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          if (this._typeOfRoad != null) {
                            if (_formKey.currentState.validate()) {
                              _calculate();
                            }
                          } else {}
                        }),
                  ),
                ),
                Text(
                  _info,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          )),
    );
  }
}
