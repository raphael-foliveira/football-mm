import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Player } from '../../players/entities/player.entity';
import { Game } from '../../games/entities/game.entity';

export enum Card {
  None = '',
  Yellow = 'yellow',
  Red = 'red',
}

@Entity()
export class Foul {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({
    type: 'enum',
    enum: Card,
    default: Card.None,
  })
  card: Card;

  @ManyToOne(() => Player, (player) => player.foulsGiven)
  offendingPlayer: Player;

  @ManyToOne(() => Player, (player) => player.foulsTaken, { nullable: true })
  victimPlayer?: Player;

  @Column()
  minute: number;

  @ManyToOne(() => Game, (game) => game.fouls)
  game: Game;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
