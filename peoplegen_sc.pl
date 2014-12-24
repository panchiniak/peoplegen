#!/usr/bin/perl -w
use strict;
use utf8;

use Business::BR::CPF; 
use Data::RandomPerson::Names::SpanishMale;
use Data::RandomPerson::Names::SpanishFemale;
use String::Random;
use Badger::Timestamp;

my $fim = shift;
my $inicio = 0;
my $cidades = shift;

open (my $in, "<", $cidades) || die "Can not open", $cidades, ": $!";

my @cidades_lista;

while (1) {
  my $line = <$in>;
  last unless $line;
  for ($line) {
    s/\n//;
    push(@cidades_lista, $line);
  }
}
close $in;

my $numero_cidades = @cidades_lista;
my $string_gen = String::Random->new;

my $dois_digitos = '\d\d';
my $quatro_digitos = $dois_digitos.$dois_digitos;
my $onze_digitos = $quatro_digitos.$quatro_digitos.$dois_digitos.'\d';
my $quatorze_digitos = $onze_digitos.$dois_digitos.'\d';
my $cinquenta_digitos = $quatorze_digitos.$quatorze_digitos.$quatorze_digitos.$quatro_digitos.$quatro_digitos;

my @colaborador = ('1','2');
my @valores_elegibilidade = ('0', '1');


while ($inicio<$fim){
#nomes de pessoas tem no mínimo duas palavras e no maximo quatro
  my $prenomes = int(rand(2)) + 2;
  my $cidade_atual_homem = int(rand(430)) + 1; 
  my $cidade_atual_mulher = int(rand(430)) + 1;  
  my $tipo = int(rand(2));
  my $familiar = int(rand(9));
  my $random_timestamp = int(rand(-99999999))+9999999;
  my $stamp = Badger::Timestamp->new($random_timestamp*10);
  my $data = $stamp->format('%d/%m/%Y');
  
  my $codigo_sub_industria = $string_gen->randregex($quatorze_digitos);
  my $nome_sub_industria = $string_gen->randregex($cinquenta_digitos);
  my $nit = $string_gen->randregex($onze_digitos);
 
  my $faixa_desconto_inteiro = int(rand(999));
  my $faixa_desconto_decimal = int(rand(80))+10;
  my $faixa_desconto = $faixa_desconto_inteiro.",".$faixa_desconto_decimal;

=head1 CNPJ 
  CNPJ : Campo não obrigatório.
  Deve conter apenas numeros.
  Máximo de 14 caracteres.
=cut
  my $cnpj = $codigo_sub_industria;
=head1 Nome Pagador
  #Nome pagador :
  #Campo não obrigatório.
  #Quando preenchido deve conter o nome da empresa onde o colaborador é registrado.
  #Máximo de 50 caracteres.
=cut 
  my $nome_pagador = $string_gen->randpattern('ssssssssssssssssssssssssssssssssssssssssssssssssss');

=head1 Outros Requisitos
  Permite cadastro :
  Campo não obrigatório.
  Informa se o colaborador é elegível ou não para a campanha em questão. 
  Quando preenchido deve conter a seguinte formatação:
  0 - não permitido
  1 - permitido
  Máximo 1 caracter
  @valores_elegibilidade = ('0', '1'); 

  Permite dependente : 
  Campo não obrigatório.
  Informa se o colaborador pode incluir dependente ou não para a campanha 
  em questão. Quando preenchido deve conter a seguinte formatação:
  0 - não permitido
  1 - permitido
  Máximo 1 caracter.  

  Vacina :
  Campo não obrigatório.
  Quando preenchido deve conter no máximo 17 digitos, separados por ";".
  
  #Obss.: Segundo a segunda aba da planilha, o campo vacina contém até 
  6 identificações de vaicnas, separadas por ponto-e-vírgula. Esse
  campo deve receber um tratamento adicional. Caso contrário,
  irá quebrar o arquivo CSV, que usa ponto-e-vírgula como delimitador.

  Autorização : Campo não obrigatorio.
  Define o tipo de campanha, se haverá adesao dos colaboradores ou se 
  todos estão convidados a participar, sem que preencham o 
  requerimento de adesao.
  Quando preenchido deve seguir a seguinte formatação:
  1 - campanhas pre-autorizadas
  2 - campanha com adesão
  Máximo 1 caracter.

  CBO - família :
  Campo não obrigatorio.
  Código da familia do CBO. Deve conter apenas números. Não aceita 
  caracteres especiais como ponto, traço, espaço, entre outros.
  Máximo 4 caracteres.
=cut
  my $codigo_familia = $string_gen->randregex($quatro_digitos);

=head1 CBO Ocupação
  CBO ocupação : Campo não obrigatorio.
  Codigo de ocupação do CBO. Deve conter apenas numeros. Não 
  aceita caracteres especiais como espaço, traço, virgula entre outros.
  Máximo 2 caracteres.
=cut
  my $codigo_ocupacao = $string_gen->randregex($dois_digitos);

  my $nome_index = 0;
  my $nome_homem = "";
  my $nome_mulher = "";
  while ($nome_index < $prenomes){
    my $homem = Data::RandomPerson::Names::SpanishMale->new();
    my $mulher = Data::RandomPerson::Names::SpanishFemale->new();

    $nome_homem = $homem->get()." ".$nome_homem;
    $nome_mulher = $mulher->get()." ".$nome_mulher;

    $nome_index++;
  }

  #linha com nome masculino
  my $correct_cpf = Business::BR::CPF::random_cpf();
  print "$codigo_sub_industria;$nome_sub_industria;$correct_cpf;";
  for ($nome_homem){
    s/ $//;
  }
  print $nome_homem;  
  print ";$nit;M;$colaborador[$tipo];$familiar;$data;$faixa_desconto;$cnpj;$nome_pagador;$valores_elegibilidade[$tipo];$valores_elegibilidade[$tipo];Vacina;$colaborador[$tipo];$codigo_familia;$codigo_ocupacao;$cidades_lista[$cidade_atual_homem];SC;contato\@taller.net.br\n";

  #linha com nome feminino
  $correct_cpf = Business::BR::CPF::random_cpf();
  print "$codigo_sub_industria;$nome_sub_industria;$correct_cpf;";
  for ($nome_mulher){
    s/ $//;
  }
  print $nome_mulher;
  print ";$nit;F;$colaborador[$tipo];$familiar;$data;$faixa_desconto;$cnpj;$nome_pagador;$valores_elegibilidade[$tipo];$valores_elegibilidade[$tipo];Vacina;$colaborador[$tipo];$codigo_familia;$codigo_ocupacao;$cidades_lista[$cidade_atual_mulher];SC;contato\@taller.net.br\n";

  $inicio++;
}
