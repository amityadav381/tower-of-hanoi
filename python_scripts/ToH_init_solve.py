import random
from typing import List, Tuple

# Constants for Peg IDs
PEG_A, PEG_B, PEG_C = 0, 1, 2
PEG_NAMES = {PEG_A: "Peg A (0)", PEG_B: "Peg B (1)", PEG_C: "Peg C (2)"}

def generate_random_state(min_disks: int = 7, max_disks: int = 8) -> Tuple[List[List[int]], int]:
    """
    Generates a random valid state for the Tower of Hanoi puzzle using 3 lists.

    State Format:
        A list of 3 lists: [peg_0_stack, peg_1_stack, peg_2_stack].
        Each inner list contains integer disk sizes.
        Index 0 of the inner list is the BOTTOM disk.
        
        Example: [[3, 1], [2], []] means:
        - Peg 0 has disk 3 (bottom) and disk 1 (top).
        - Peg 1 has disk 2.
        - Peg 2 is empty.

    Args:
        min_disks: Minimum number of disks (inclusive).
        max_disks: Maximum number of disks (inclusive).

    Returns:
        A tuple containing:
        1. The state (List[List[int]]).
        2. The randomly chosen target peg ID (int).
    """
    # 1. Randomly choose the number of disks
    num_disks = random.randint(min_disks, max_disks)

    # 2. Initialize 3 empty pegs
    pegs = [[], [], []]

    # 3. Assign disks from Largest (N) down to Smallest (1).
    # By placing larger disks first, we ensure that if multiple disks end up
    # on the same peg, the larger ones are at lower indices (bottom),
    # maintaining a valid Tower of Hanoi state.
    for disk_size in range(num_disks, 0, -1):
        chosen_peg = random.randint(0, 2)
        pegs[chosen_peg].append(disk_size)

    # 4. Randomly choose the final target peg
    target_peg = random.randint(0, 2)

    return pegs, target_peg

def calculate_min_moves(pegs: List[List[int]], target_peg: int) -> int:
    """
    Computes the minimum number of moves to transfer all disks to the target peg.

    Args:
        pegs: List of 3 lists representing the current state.
        target_peg: The final destination peg ID.

    Returns:
        The minimum number of moves (integer).
    """
    # 1. Pre-process the state to find the location of every disk.
    # We map disk_size -> peg_id for O(1) lookup during the algorithm.
    disk_locations = {}
    num_disks = 0
    
    for peg_id, stack in enumerate(pegs):
        for disk in stack:
            disk_locations[disk] = peg_id
            if disk > num_disks:
                num_disks = disk
    
    min_moves = 0
    
    # The target peg for the current sub-problem (disks 1 to i).
    # Initially, the target is the overall target peg.
    current_target = target_peg

    # Iterate from the largest disk (N) down to the smallest (1)
    # This logic is based on the recursive structure of the puzzle.
    for i in range(num_disks, 0, -1):
        disk_size = i
        current_peg = disk_locations[disk_size]

        if current_peg != current_target:
            # If disk i is not on the target peg, it must move.
            # To move disk i, all smaller disks (1 to i-1) must first move 
            # to the auxiliary peg. This takes 2^(i-1) - 1 moves. 
            # Then disk i moves (1 move). Total added: 2^(i-1).
            min_moves += (2 ** (disk_size - 1))

            # The smaller disks (1 to i-1) must now end up on the auxiliary peg
            # to clear the way for disk i (or to sit on top of it later).
            # The auxiliary peg is the one that is neither the current nor target.
            # (0 + 1 + 2) - current - target gives the remaining peg ID.
            auxiliary_peg = 3 - current_peg - current_target
            current_target = auxiliary_peg
            
        # If disk i IS on the target peg, we effectively ignore it and 
        # solve the sub-problem for i-1 with the same target.

    return min_moves

def print_state_info(pegs: List[List[int]], target_peg: int):
    """Prints the puzzle configuration and the goal."""
    
    # Calculate total disks by counting all elements
    num_disks = sum(len(p) for p in pegs)
    
    print("\n--- Tower of Hanoi Initial State ---")
    print(f"Number of Disks (N): {num_disks}")
    print(f"Target Peg: {PEG_NAMES[target_peg]}\n")

    # Find the maximum height for aligned printing
    max_height = 0
    if num_disks > 0:
        max_height = max(len(p) for p in pegs)

    # Generate the visual representation (top down)
    print("Peg A (0) | Peg B (1) | Peg C (2)")
    print("---------------------------------")
    
    # Print rows from top to bottom
    # Because index 0 is bottom, the top index is len(stack) - 1
    # We iterate height `h` from max_height - 1 down to 0
    for h in range(max_height - 1, -1, -1):
        line = []
        for peg_id in [PEG_A, PEG_B, PEG_C]:
            stack = pegs[peg_id]
            
            # Check if this peg has a disk at height `h`
            if h < len(stack):
                disk_size = stack[h]
                # Format disk as centered string (e.g., "|==1==|")
                display = f"|{'=' * (disk_size)}{disk_size}{'=' * (disk_size)}|"
            else:
                # Empty space
                display = " " * (num_disks * 2 + 3)
            
            # Pad for column alignment
            padding_width = num_disks * 2 + 3 
            line.append(display.center(padding_width))

        print(f"{line[0]}|{line[1]}|{line[2]}")

    # Print the base
    base_width = num_disks * 2 + 3
    base_line = f"{'-' * base_width}|{'-' * base_width}|{'-' * base_width}"
    print(base_line)


# --- Main Execution ---
if __name__ == "__main__":
    # 1. Generate a random valid state (List of Lists)
    pegs, target_peg = generate_random_state(min_disks=7, max_disks=7)
    
    # 2. Display the generated state
    print_state_info(pegs, target_peg)
    
    # 3. Compute minimum moves
    minimum_moves = calculate_min_moves(pegs, target_peg)
    
    # 4. Display Result
    num_disks = sum(len(p) for p in pegs)
    print(f"\n--- Calculation Result ---")
    print(f"The minimum number of moves to move all {num_disks} disks")
    print(f"to {PEG_NAMES[target_peg]} is: {minimum_moves}")
    print(f"(Standard moves 2^N - 1: {2**num_disks - 1})")