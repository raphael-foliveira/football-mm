import { Inject, Injectable } from '@nestjs/common';
import { CreateGameDto } from './dto/create-game.dto';
import { UpdateGameDto } from './dto/update-game.dto';
import { Repository } from 'typeorm';
import { Game } from './entities/game.entity';

@Injectable()
export class GameService {
  constructor(
    @Inject('GAMES_REPOSITORY') private repository: Repository<Game>,
  ) {}

  create(createGameDto: CreateGameDto) {
    return this.repository.create(createGameDto);
  }

  findAll() {
    return this.repository.find();
  }

  findOne(id: number) {
    return this.repository.findOne({ where: { id } });
  }

  update(id: number, updateGameDto: UpdateGameDto) {
    return this.repository.update({ id }, updateGameDto);
  }

  async remove(id: number) {
    const player = await this.findOne(id);
    return this.repository.remove(player);
  }
}
