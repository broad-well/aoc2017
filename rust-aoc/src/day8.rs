use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};

enum Operation {
    INC, DEC,
}
enum PredicateOper {
    LEQ,
    LT,
    EQ,
    NEQ,
    GEQ,
    GT,
}

struct Instruction {
    register_name: String,
    operation: Operation,
    operand: i32,
    predicate_reg_name: String,
    predicate_operation: PredicateOper,
    predicate_operand: i32
}

fn parse_line(line: &str) -> Instruction {
    let clauses = line.split(" if ").collect::<Vec<_>>();
    let operation = clauses[0].split(' ').collect::<Vec<_>>();
    let predicate = clauses[1].split(' ').collect::<Vec<_>>();

    Instruction {
        register_name: operation[0].to_owned(),
        operation: match operation[1] {
            "dec" => Operation::DEC,
            "inc" => Operation::INC,
            _ => Operation::DEC
        },
        operand: operation[2].parse::<i32>().unwrap(),
        predicate_reg_name: predicate[0].to_owned(),
        predicate_operation: match predicate[1] {
            "<" => PredicateOper::LT,
            "<=" => PredicateOper::LEQ,
            "==" => PredicateOper::EQ,
            "!=" => PredicateOper::NEQ,
            ">=" => PredicateOper::GEQ,
            ">" => PredicateOper::GT,
            _ => PredicateOper::EQ,
        },
        predicate_operand: predicate[2].parse::<i32>().unwrap(),
    }
}

fn change_register(registers: &mut HashMap<String, i32>, name: &str, oper: &Operation, operand: i32) {
    let value = *registers.get(name).unwrap_or(&0i32);
    registers.insert(name.to_owned(), match oper {
        &Operation::INC => value + operand,
        &Operation::DEC => value - operand,
    });
}

fn predicate_fulfilled(registers: &mut HashMap<String, i32>, reg_name: &str, oper: &PredicateOper, operand: i32) -> bool {
    let value = *registers.get(reg_name).unwrap_or(&0i32);
    match oper {
        &PredicateOper::EQ => value == operand,
        &PredicateOper::GEQ => value >= operand,
        &PredicateOper::GT => value > operand,
        &PredicateOper::NEQ => value != operand,
        &PredicateOper::LT => value < operand,
        &PredicateOper::LEQ => value <= operand,
    }
}

fn execute_line(registers: &mut HashMap<String, i32>, line: &Instruction) {
    if predicate_fulfilled(registers, &line.predicate_reg_name, &line.predicate_operation, line.predicate_operand) {
        change_register(registers, &line.register_name, &line.operation, line.operand);
    }
}

pub fn main() {
    let input = BufReader::new(File::open("data-day8.txt").expect("Data file not found"));
    let input_lines = input.lines().map(|x| x.unwrap()).map(|x| parse_line(&x)).collect::<Vec<_>>();

    let mut registers: HashMap<String, i32> = HashMap::new();
    let mut highest: Vec<i32> = Vec::new();

    for line in input_lines.iter() {
        execute_line(&mut registers, line);
        if let Some(max) = registers.values().clone().max() {
            highest.push(*max);
        }
    }
    println!("Part 1: {}", registers.values().max().expect("No registers?!"));
    println!("Part 2: {}", highest.iter().max().unwrap());
}