use std::ops::BitXor;

const INPUT: &'static str = "130,126,1,11,140,2,255,207,18,254,246,164,29,104,0,224";
//const INPUT: &'static str = "";

fn reverse_next(seq: &mut Vec<u8>, position: u8, length: u8) {
    let indices: Vec<_> = (position as u32..(position as u32 + length as u32))
            .map(|x| (x as u32) % seq.len() as u32).collect();
    let values: Vec<_> = indices.iter().map(|&x| seq[x as usize]).rev().collect();
    indices.iter().zip(values).for_each(|(i, v)| seq[*i as usize] = v);
}

fn run_hash((lengths, mut skip_size, mut pos): (&Vec<u8>, u32, u8)) -> (Vec<u8>, u32, u8) {
    let mut seq: Vec<u8> = (0..255).collect();
    seq.push(255);
    // Would be nice if (0..256) worked for Vec<u8>s

    for length in lengths {
        reverse_next(&mut seq, pos, *length);
        pos = ((pos as u32 + *length as u32 + skip_size) % 256) as u8;
        skip_size += 1;
    }
    (seq, skip_size, pos)
}

fn densify_hash(sparse: &Vec<u8>) -> Vec<u32> {
    sparse.chunks(16).map(|x| x.iter().map(|&x| x as u32).fold(0u32, BitXor::bitxor)).collect()
}

pub fn main() {
    let input1: Vec<u8> = INPUT.split(',').map(|x| x.parse().unwrap()).collect();

    // Part 1
    let (output, _, _) = run_hash((&input1, 0, 0));
    println!("Part 1: {}", output[0] as u32 * output[1] as u32);

    // Part 2
    let mut input2 = String::from(INPUT).into_bytes();
    input2.append(&mut vec![17, 31, 73, 47, 23]);
    let mut state = (vec![], 0u32, 0u8);
    for _ in 0..64 {
        state = run_hash((&input2, state.1, state.2));
    }
    println!("{}", densify_hash(&state.0).into_iter().map(|dense| format!("{:02x}", dense)).collect::<Vec<String>>().join(""));
}