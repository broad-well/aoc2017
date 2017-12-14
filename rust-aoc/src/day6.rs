//const INPUT: &'static str = "10	3	15	10	5	15	5	15	9	2	5	8	5	2	3	6";
const INPUT: &'static str = "0	2	7	0";
		
use std::collections::HashSet;

fn spread_bank(banks: &mut Vec<u32>) {
    let index = banks.iter().enumerate()
            .max_by_key(|x| x.1)
            .expect("Bad input bank")
            .0;
    let chosen_orig = banks[index] as usize;
    banks[index] = 0;

    (0..banks.len())
            .cycle()
            .skip(index + 1)
            .take(chosen_orig)
            .for_each(|x| banks[x] += 1);
}

pub fn main() {
    let input: Vec<u32> = INPUT
            .split("\t")
            .map(|x| x.parse::<u32>().expect("Unsanitary input"))
            .collect();

    let mut seen: HashSet<Vec<u32>> = HashSet::new();
    let mut current = input.clone();

    while !seen.contains(&current) {
        seen.insert(current.clone());
        spread_bank(&mut current);
    }
    println!("Steps required: {}, stopped at {:?}", seen.len(), current);
}